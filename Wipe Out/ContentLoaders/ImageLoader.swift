//
//  ImageLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 25.11.21.
//

import Photos
import SwiftUI

enum ImageLoaderError: Error {
    case notLoaded
}

class ImageLoader {
    
    private let cache = Cache<String, UIImage>()
    private let imageManager: PHCachingImageManager
    typealias Handler = (Result<UIImage, Error>) -> Void
    
    static let shared = ImageLoader()
    
    init(imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.imageManager = imageManager
    }
    
    @MainActor
    func load(card: Card) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            load(card: card) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    private func load(card: Card, completion: @escaping Handler) {
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            if let image = image,
               let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool,
               isDegraded == false {
                self.cache[card.asset.localIdentifier] = image
                completion(.success(image))
                return
            }
        }
        
        if let cachedImage = cache[card.asset.localIdentifier] {
            print("cached image")
            completion(.success(cachedImage))
            return
        } else {
            imageManager.requestImage(for: card.asset,
                                      targetSize: CGSize(width: 4032, height: 4032),
                                      contentMode: .aspectFit,
                                      options: nil,
                                      resultHandler: resultHandler)
        }
    }
}
