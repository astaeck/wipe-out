//
//  ScreenshotLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 28.06.22.
//

import SwiftUI
import Photos

class ScreenshotLoader {
    private var setSelected: Bool = true
    
    func collectionsWith(_ cards: [Card]) -> [SimilarCollection] {
        let screenshots: [Card] = cards.filter { $0.asset.mediaSubtypes.contains(.photoScreenshot) }
        if setSelected {
            screenshots.forEach { $0.isSelected = true }
        }
        return [SimilarCollection(cards: screenshots)]
    }
    
    func deselectCardsIn(_ collection: SimilarCollection)  {
        setSelected = false
        _ = collection.cards.map({ $0.isSelected = false })
    }
}
