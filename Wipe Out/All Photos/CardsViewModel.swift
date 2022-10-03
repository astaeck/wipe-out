//
//  CardsViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 24.11.21.
//

import Photos
import AVKit

final class CardsViewModel: LoadableObject {
    
    typealias Output = [Card]
    @Published private(set) var state: LoadingState<[Card]> = .idle

    private let photoLibrary: PHPhotoLibrary
    private var allAssets: [PHAsset] = []

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
            }
        }
    }
    
    // MARK: - Private
    
    private func createInitialCardView() {
        let cards = allAssets.map { Card(asset: $0) }
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
