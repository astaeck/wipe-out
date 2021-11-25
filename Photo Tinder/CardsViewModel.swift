//
//  CardsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos

class CardsViewModel: ObservableObject {
    
    private var allPhotos = PHFetchResult<PHAsset>()
    @Published var cards = [Card]()
    
    init() {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
          return
        }

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                self?.fetchPhotos()
            }
        }
    }
    
    func fetchPhotos() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
          NSSortDescriptor(
            key: "creationDate",
            ascending: false)
        ]

        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        cards = [Card(asset: allPhotos[0])]
    }
}
