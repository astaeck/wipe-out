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
    private var assetsToDelete: [PHAsset] = []
    private let photoLibrary: PHPhotoLibrary

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }

    func addToDeletionSelection(asset: PHAsset) {
        self.assetsToDelete.append(asset)
        print(assetsToDelete.count)
    }
    
    func deleteAssets() {
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(self.assetsToDelete as NSArray)
        }, completionHandler: {success, _ in
            if success {
                self.assetsToDelete.removeAll()
            }
        })
    }
    
    func resetSelection() {
        assetsToDelete.removeAll()
        load()
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
            let allAssets = PHAsset.fetchAssets(with: allPhotosOptions)
            var cards = [Card]()
            DispatchQueue.main.async {
                allAssets.enumerateObjects { (object, index, _) -> Void in
                    cards.append(Card(index: index, asset: object))
                }
                self.state = .loaded(cards)
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
