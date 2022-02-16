//
//  ImageLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 25.11.21.
//

import Photos
import SwiftUI

class ImageLoader: LoadableObject {

    typealias Output = UIImage
    @Published private(set) var state: LoadingState<UIImage> = .idle
    private let imageManager: PHCachingImageManager
    private let asset: PHAsset
    private var cachedImage: UIImage?

    init(asset: PHAsset, imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.imageManager = imageManager
        self.asset = asset
    }
    
    func load() {
        state = .loading

        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                //self.state = .failed("Image download failed")
                return
            }
            self.cachedImage = image
            DispatchQueue.main.async {
                self.state = .loaded(image)
            }
        }
        
        if let image = cachedImage {
            DispatchQueue.main.async {
                self.state = .loaded(image)
            }
        } else {
            imageManager.requestImage(for: asset,
                   targetSize: CGSize(width: 4032, height: 4032),
                   contentMode: .aspectFit,
                   options: nil,
                   resultHandler: resultHandler)
        }
    }
}
