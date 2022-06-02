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
    @Published private(set) var state: LoadingState<[Card]> = .idle
    private(set) var cards: [Card] = []
    private let photoLibrary: PHPhotoLibrary
    private var allAssets: [PHAsset] = []
    private let paginationIndex = 25
    private var canResetLastCard = true

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
                self.createCards()
            }
        }
    }

    func handleSwipe(forCard card: Card) {
        guard var index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if card.x < 0 {
            let card = cards[index]
            card.isSelected = true
        }
        index += 1
        
        guard index < cards.count else {
            loadMoreCards()
            return
        }
        
        if card.x < 0 || card.x > 0 {
            let nextCard = cards[index]
            nextCard.isEnabled = true
        }
        canResetLastCard = true
    }
    
    func resetAll() {
        cards.forEach { resetSelectedCard(withID: $0.id) }
    }
    
    func resetLast() {
        guard canResetLastCard,
              let card = cards.reversed().first(where: { $0.x != 0 }) else { return }
        resetSelectedCard(withID: card.id)
    }
    
    func deleteAssets() {
        let cardsToDelete = cards.filter { $0.isSelected }
        guard cardsToDelete.count != 0 else { return }
        let assetsToDelete = cardsToDelete.map { $0.asset }
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }, completionHandler: {success, _ in
            if success {
                DispatchQueue.main.async {
                    self.cards = self.cards.filter { $0.isSelected == false }
                }
            }
        })
    }
    
    private func resetSelectedCard(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let card = cards[index]
        card.x = 0
        card.y = 0
        card.degree = 0
        card.isSelected = false
        cards[index] = card
        canResetLastCard = false
    }
    
    private func loadMoreCards() {
        let newCards = (cards.count..<cards.count + paginationIndex).map { Card(asset: self.allAssets[$0]) }
        newCards.first?.isEnabled = true
        cards.append(contentsOf: newCards)
        state = .loaded(newCards.reversed())
    }
    
    private func createCards() {
        var newCards: [Card] = []
        if allAssets.count < paginationIndex {
            newCards = allAssets.map { Card(asset: $0) }
        } else {
            newCards = (cards.count..<cards.count + paginationIndex).map { Card(asset: self.allAssets[$0]) }
        }
        cards.append(contentsOf: newCards)
        if cards.count <= paginationIndex {
            cards.first?.isEnabled = true
        } else {
            cards[paginationIndex].isEnabled = true
        }
        state = .loaded(cards.reversed())
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
