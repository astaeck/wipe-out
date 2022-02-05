//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI
import Photos

class SimilarAssetsViewModel: LoadableObject {
    typealias Output = [SimilarCollection]
    @Published private(set) var state: LoadingState<[SimilarCollection]> = .idle
    private let imageManager: PHCachingImageManager
    private let cards: [Card]
    var imageData: [Data] = []
    let group = DispatchGroup()

    init(cards: [Card],
         imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.cards = cards
        self.imageManager = imageManager
    }

    func load() {
//        state = .loaded([SimilarCollection(cards: [cards[0], cards[1], cards[2]])])
        
        let cards = [cards[0], cards[1], cards[2], cards[3]]
    
        cards.forEach { createData($0.asset) }
        
        group.notify(queue: DispatchQueue.main, execute: {

            print("Finished all requests.")

        })
    }
    
    private func createData(_ asset: PHAsset) {
        group.enter()

        let resultHandler: (Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void = { data, _ , _ , _ in
            guard let data = data  else { return }
            self.imageData.append(data)
            self.group.leave()
        }
        imageManager.requestImageDataAndOrientation(for: asset, options: nil, resultHandler: resultHandler)
    }
}
