//
//  CardsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos
import SwiftUI

class CardsViewModel: ObservableObject {
    
    private var allAssets = PHFetchResult<PHAsset>()
    @Published private(set) var cards = [Card]()
    
    func fetchAssets() {
        getPermissionIfNecessary { granted in
          guard granted else { return }
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [
                NSSortDescriptor(
                    key: "creationDate",
                    ascending: false)
            ]
            allPhotosOptions.fetchLimit = 100
            self.allAssets = PHAsset.fetchAssets(with: allPhotosOptions)

            DispatchQueue.main.async {
                self.allAssets.enumerateObjects { (object, index, _) -> Void in
                    let card = Card(index: index, asset: object)
                    self.cards.append(card)
                }
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
