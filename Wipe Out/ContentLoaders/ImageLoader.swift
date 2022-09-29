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

final class ImageLoader {
    
    private let imageManager: PHCachingImageManager
    typealias Handler = (Result<UIImage, Error>) -> Void
    
    static let shared = ImageLoader()
    
    init(imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.imageManager = imageManager
    }

    func loadImage(for card: Card) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            loadImage(for: card) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    private func loadImage(for card: Card, completion: @escaping Handler) {
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            if let image = image,
               let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool,
               isDegraded == false {
                return completion(.success(image))
            }
        }
        
        imageManager.requestImage(for: card.asset,
                                  targetSize: CGSize(width: 4032, height: 4032),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: resultHandler)
    }
}
