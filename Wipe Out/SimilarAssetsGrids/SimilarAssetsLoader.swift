//
//  SimilarAssetsLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 02.06.22.
//

import SwiftUI
import Photos


class SimilarAssetsLoader {
    
    class func collectionsWith(_ cards: [Card]) -> [SimilarCollection] {
        let cardsWithoutScreenshots = cards.filter { !$0.asset.mediaSubtypes.contains(.photoScreenshot) }
        let groupedCards = Dictionary(grouping: cardsWithoutScreenshots.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        return similarGroupedCards.map { SimilarCollection(cards: $0) }
    }
}

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
