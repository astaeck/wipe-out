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
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }

    init(asset: PHAsset) {
        fetchImageAsset(asset, targetSize: CGSize(width: 4032, height: 4032), completionHandler: nil)
    }
    
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> Void)?) {
        guard let asset = asset else {
            completionHandler?(true)
            return
        }
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                completionHandler?(true)
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            completionHandler?(true)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
               targetSize: size,
               contentMode: contentMode,
               options: options,
               resultHandler: resultHandler)
    }
}
