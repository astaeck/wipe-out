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
    private(set) var cardsToDelete: [Card] = []
    private var cards: [Card] = []
    private let photoLibrary: PHPhotoLibrary

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }

    func selectCardForDeletion(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        cardsToDelete.append(cards[index])
    }
    
    func resetAll() {
        cardsToDelete.forEach { resetSelectedCard(withID: $0.id) }
        cardsToDelete.removeAll()
    }
    
    func resetLast() {
        guard let card = cardsToDelete.last else { return }
        resetSelectedCard(withID: card.id)
    }
    
    func resetSelectedCard(withID id: UUID) {
        guard let index = cardsToDelete.firstIndex(where: { $0.id == id }) else { return }
        let card = cardsToDelete[index]
        cardsToDelete.remove(at: index)
        card.x = 0
        card.y = 0
        card.degree = 0
    }
    
    func deleteAssets() {
        guard cardsToDelete.count != 0 else { return }
        let assetsToDelete = cardsToDelete.map { $0.asset }
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }, completionHandler: {success, _ in
            if success {
                self.cardsToDelete.removeAll()
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
