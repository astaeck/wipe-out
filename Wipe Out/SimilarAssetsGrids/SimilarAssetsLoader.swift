//
//  SimilarAssetsLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 02.06.22.
//

import SwiftUI
import Photos

class SimilarAssetsLoader {
    private(set) var collections: [SimilarCollection] = []
    
    func loadSimilarCollectionsWith(_ cards: [Card]) {
        let cardsWithoutVideos = cards.filter { $0.asset.mediaType != .video }
        let cardsWithoutScreenshots = cardsWithoutVideos.filter { !$0.asset.mediaSubtypes.contains(.photoScreenshot) }
        let groupedCards = Dictionary(grouping: cardsWithoutScreenshots.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        
        
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        collections = similarGroupedCards.map { SimilarCollection(cards: $0) }
        
    }
    
    func updateSimilarCollectionsWith(_ deletedCards: [Card]) {
        collections.forEach({ $0.cards = $0.cards.filter({ card in !deletedCards.contains(card) }) })
    }
}
