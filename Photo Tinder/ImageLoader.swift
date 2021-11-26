//
//  ImageLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 25.11.21.
//

import Combine
import Photos
import SwiftUI

class ImageLoader: ObservableObject {
    private let imageManager: PHImageManager
    private let asset: PHAsset
    var didChange = PassthroughSubject<UIImage, Never>()
    private var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }

    init(asset: PHAsset, imageManager: PHImageManager = PHImageManager.default()) {
        self.imageManager = imageManager
        self.asset = asset
        fetchImageAsset(targetSize: CGSize(width: 4032, height: 4032))
    }
    
    private func fetchImageAsset(targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil) {
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        PHImageManager.default().requestImage(
            for: asset,
               targetSize: size,
               contentMode: contentMode,
               options: options,
               resultHandler: resultHandler)
    }
}
