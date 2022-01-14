//
//  CardsViewModel.swift
//  Photo Tinder
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
    private var paginationIndex = 0
    
    var numberOfAssets: Int {
        allAssets.count
    }

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }
    
    func handleSwipe(forCard card: Card) {
        guard var index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if card.x < 0 {
            let card = cards[index]
            card.isSelected = true
        }
        index += 1
        
        guard index < cards.count else {
            createCards()
            return
        }
        
        if card.x < 0 || card.x > 0 {
            let nextCard = cards[index]
            nextCard.isEnabled = true
        }
    }
    
    func resetAll() {
        cards.forEach { resetSelectedCard(withID: $0.id) }
    }
    
    func resetLast() {
        guard let card = cards.reversed().first(where: { $0.x != 0 }) else { return }
        resetSelectedCard(withID: card.id)
    }
    
    func resetSelectedCard(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let card = cards[index]
        card.x = 0
        card.y = 0
        card.degree = 0
        card.isSelected = false
        cards[index] = card
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

    func load() {
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
    
    func reverseOrder() {
        cards = cards.reversed()
        state = .loaded(cards)
    }
    
    private func createCards() {
        let newCards = (paginationIndex..<paginationIndex + 25).map { Card(asset: self.allAssets[$0]) }
        cards.append(contentsOf: newCards)
        if paginationIndex < 1 {
            cards.first?.isEnabled = true
        } else {
            cards[paginationIndex].isEnabled = true
        }
        state = .loaded(cards.reversed())
        paginationIndex += 25
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
