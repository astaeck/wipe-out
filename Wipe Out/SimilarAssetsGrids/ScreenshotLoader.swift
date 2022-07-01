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
    private var collections: [SimilarCollection] = []
    
    func collectionsWith(_ newCards: [Card]) -> [SimilarCollection] {
        
        if collections.isEmpty == false {
            collections.forEach({ $0.cards = $0.cards.filter({ card in newCards.contains(card) }) })
        } else {
            let screenshots: [Card] = newCards.filter { $0.asset.mediaSubtypes.contains(.photoScreenshot) }
            if setSelected {
                screenshots.forEach { $0.isSelected = true }
            }
            collections = [SimilarCollection(cards: screenshots)]
        }
        
        return collections
    }
    
    func deselectCardsIn(_ collection: SimilarCollection)  {
        setSelected = false
        _ = collection.cards.map({ $0.isSelected = false })
    }
}
