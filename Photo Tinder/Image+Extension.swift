//
//  UImageView+Extension.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import UIKit
import SwiftUI
import Photos

extension Image {
    
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((UIImage) -> Void)?) {
        guard let asset = asset else {
            completionHandler?(UIImage())
            return
        }
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                completionHandler?(UIImage())
                return
            }
            completionHandler?(image)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
               targetSize: size,
               contentMode: contentMode,
               options: options,
               resultHandler: resultHandler)
    }
}
