//
//  ImageLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 25.11.21.
//

import Combine
import Photos
import SwiftUI

class ImageLoader: LoadableObject {

    typealias Output = UIImage
    @Published private(set) var state: LoadingState<UIImage> = .idle
    private let imageManager: PHImageManager
    private let asset: PHAsset

    init(asset: PHAsset, imageManager: PHImageManager = PHImageManager.default()) {
        self.imageManager = imageManager
        self.asset = asset
    }
    
    func load() {
        state = .loading

        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                self.state = .failed("Image download failed")
                return
            }
            DispatchQueue.main.async {
                self.state = .loaded(image)
            }
        }
        
        PHImageManager.default().requestImage(
            for: asset,
               targetSize: CGSize(width: 4032, height: 4032),
               contentMode: .aspectFit,
               options: nil,
               resultHandler: resultHandler)
    }
}
