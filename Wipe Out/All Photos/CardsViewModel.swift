//
//  CardsViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos
import SwiftUI
import AVKit

class CardsViewModel: LoadableObject {
    
    typealias Output = [Card]
    private let photoLibrary: PHPhotoLibrary

    @Published private(set) var state: LoadingState<[Card]> = .idle
    private(set) var cards: [Card] = []
    private(set) var similarCollections: [SimilarCollection] = []

    private var allAssets: [PHAsset] = []
    private var paginationIndex = 25

    var numberOfAssets: Int {
        allAssets.count
    }

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }
    
    func load() {
        guard allAssets.isEmpty else { return }
        DispatchQueue.main.async {
            self.state = .loading
        }

        getPermissionIfNecessary { granted in
          guard granted else { return }
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchedAssets = PHAsset.fetchAssets(with: allPhotosOptions)
            fetchedAssets.enumerateObjects { (asset, _, _) -> Void in
                self.allAssets.append(asset)
            }
            DispatchQueue.main.async {
                self.createInitialCardView()
                self.loadSimilarCollections()
                self.loadScreenshotCollections()
            }
        }
    }

    func handleSwipe(forCard card: Card) {
        guard var index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if card.x < 0 {
            let card = cards[index]
            card.isSelected = true
            card.isPreSelected = true
            updateCollectionsWith(card)
        }
        index += 1
        
        guard index < paginationIndex else {
            loadMoreCards()
            return
        }
        
        if index < cards.count && (card.x < 0 || card.x > 0) {
            let nextCard = cards[index]
            nextCard.isEnabled = true
        }
    }
    
    func resetLast() {
        guard let card = cards.reversed().first(where: { $0.x != 0 }) else { return }
        resetSelectedCard(withID: card.id)
    }
    
    func deleteAssets() {
        let cardsToDelete = cards.filter { $0.isSelected }
        guard cardsToDelete.count != 0 else { return }
        let assetsToDelete = cardsToDelete.map { $0.asset }
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }, completionHandler: { success, _ in
            if success {
                DispatchQueue.main.async {
                    self.removeCardFromCollections(cardsToDelete)
                    self.cards = self.cards.filter { $0.isSelected == false }
                    let newCards = (self.paginationIndex - 25..<self.paginationIndex).map { self.cards[$0] }
                    self.state = .loaded(newCards.reversed())
                }
            }
        })
    }
    
    func moveCardToTrashFrom(_ collection: SimilarCollection) {
        let cards = collection.cards.filter({ $0.isPreSelected })
        cards.forEach { $0.isSelected = true }
        
    }
    
    // MARK: - Private
    
    private func loadScreenshotCollections() {
        let screenshots: [Card] = cards.filter { $0.asset.mediaSubtypes.contains(.photoScreenshot) }
        screenshots.forEach { $0.isPreSelected = true }
        similarCollections.append(contentsOf: [SimilarCollection(cards: screenshots, collectionType: .screenshot)])
    }

    private func loadSimilarCollections() {
        let cardsWithoutVideos = cards.filter { $0.asset.mediaType != .video }
        let cardsWithoutScreenshots = cardsWithoutVideos.filter { !$0.asset.mediaSubtypes.contains(.photoScreenshot) }
        let groupedCards = Dictionary(grouping: cardsWithoutScreenshots.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        similarCollections.append(contentsOf: similarGroupedCards.map { SimilarCollection(cards: $0, collectionType: .similar) })
    }
    
    private func removeCardFromCollections(_ deletedCards: [Card]) {
        similarCollections.forEach({ $0.removeCardsFromCollections(deletedCards) })
    }
    
    private func updateCollectionsWith(_ card: Card) {
        similarCollections.forEach({ $0.cards = $0.cards })
    }
    
    private func resetSelectedCard(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let card = cards[index]
        card.x = 0
        card.y = 0
        card.degree = 0
        card.isSelected = false
        card.isPreSelected = false
        updateCollectionsWith(card)
    }
    
    private func loadMoreCards() {
        let newCards = (paginationIndex..<paginationIndex + 25).map { cards[$0] }
        paginationIndex += 25
        newCards.first?.isEnabled = true
        state = .loaded(newCards.reversed())
    }
    
    private func createInitialCardView() {
        var allCards = [Card]()
        if allAssets.count < paginationIndex {
            cards = allAssets.map { Card(asset: $0) }
        } else {
            cards = (0..<paginationIndex).map { Card(asset: allAssets[$0]) }
            allCards = (paginationIndex..<allAssets.count).map { Card(asset: allAssets[$0]) }
        }
        cards.first?.isEnabled = true
        state = .loaded(cards.reversed())
        cards.append(contentsOf: allCards)
    }

    private func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
}
