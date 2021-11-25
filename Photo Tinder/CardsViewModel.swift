//
//  CardsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos
import SwiftUI

class CardsViewModel: ObservableObject {
    
    private var allPhotos = PHFetchResult<PHAsset>()
    @Published var cards = [Card]()
    
    func fetchPhotos() {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
          return
        }

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            if status == .authorized {
                let allPhotosOptions = PHFetchOptions()
                allPhotosOptions.sortDescriptors = [
                  NSSortDescriptor(
                    key: "creationDate",
                    ascending: false)
                ]

                self.allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
                DispatchQueue.main.async {
                    
                    self.allPhotos.enumerateObjects { (object, _, _) -> Void in
                        let card = Card(asset: object)
                        self.cards.append(card)
                    }
                }
            }
        }
    }
}
