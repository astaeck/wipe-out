//
//  ImageLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 25.11.21.
//

import Photos
import SwiftUI

class ImageLoader {

    private let cache = Cache<String, UIImage>()
    private let imageManager: PHCachingImageManager
    typealias Handler = (Result<UIImage, Error>) -> Void

    static let shared = ImageLoader()

    init(imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.imageManager = imageManager
    }
    
    func load(card: Card? = nil, completion: @escaping Handler) {
        guard let card = card else { return }

        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                //self.state = .failed("Image download failed")
                return
            }
            self.cache[card.id.uuidString] = image
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        if let cachedImage = cache[card.id.uuidString] {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
        } else {
            imageManager.requestImage(for: card.asset,
                   targetSize: CGSize(width: 4032, height: 4032),
                   contentMode: .aspectFit,
                   options: nil,
                   resultHandler: resultHandler)
        }
    }
}
