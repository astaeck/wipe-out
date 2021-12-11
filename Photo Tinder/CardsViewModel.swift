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

    func selectCardForDeletion(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let card = cards[index]
        card.isSelected = true
    }
    
    func resetAll() {
        cards.forEach { resetSelectedCard(withID: $0.id) }
    }
    
    func resetLast() {
        guard let card = cards.reversed().first(where: { $0.x < 0 }) else { return }
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
            allPhotosOptions.fetchLimit = 100
            let fetchedAssets = PHAsset.fetchAssets(with: allPhotosOptions)
            var allAssets: [PHAsset] = []
            fetchedAssets.enumerateObjects { (object, _, _) -> Void in
                allAssets.append(object)
            }
            DispatchQueue.main.async {
                self.cards = allAssets.map { Card(asset: $0) }
                self.state = .loaded(self.cards)
            }
        }
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
