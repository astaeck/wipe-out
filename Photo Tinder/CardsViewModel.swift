//
//  CardsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos
import SwiftUI

class CardsViewModel: LoadableObject {
    
    typealias Output = [Card]
    @Published private(set) var state: LoadingState<[Card]> = .idle
    @Published var cards: [Card] = []
    private let photoLibrary: PHPhotoLibrary

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }
    
    func handleSwipe(forCard card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if card.x < 0 {
            let card = cards[index]
            card.isSelected = true
        }
        guard index < cards.count else { return }
        let nextCard = cards[index + 1]
        nextCard.isEnabled = true
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
                self.cards = self.cards.filter { $0.isSelected }
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
            allPhotosOptions.sortDescriptors = [
                NSSortDescriptor(
                    key: "creationDate",
                    ascending: false)
            ]

            //TODO: Remove fetch limit when paginated image download implemented
            allPhotosOptions.fetchLimit = 50
            let fetchedAssets = PHAsset.fetchAssets(with: allPhotosOptions)
            var allAssets: [PHAsset] = []
            fetchedAssets.enumerateObjects { (asset, _, _) -> Void in
                allAssets.append(asset)
            }
            DispatchQueue.main.async {
                self.cards = allAssets.map { Card(asset: $0) }
                self.cards.first?.isEnabled = true
                self.state = .loaded(self.cards.reversed())
            }
        }
    }
    
    func reverseOrder() {
        cards = cards.reversed()
        state = .loaded(cards)
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
