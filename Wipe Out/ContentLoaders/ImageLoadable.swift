//
//  ImageLoadable.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 20.02.22.
//

import Foundation
import UIKit

class ImageLoadable: LoadableObject {
    typealias Output = UIImage
    @Published private(set) var state: LoadingState<UIImage> = .idle
    private let imageLoader: ImageLoader
    private let card: Card
    
    init(imageLoader: ImageLoader = ImageLoader.shared,
         card: Card) {
        self.imageLoader = imageLoader
        self.card = card
    }
    
    func load() {
        state = .loading
        
        imageLoader.load(card: card) { result in
            guard let image = try? result.get() else { return }
            self.state = .loaded(image)
        }
    }
}
