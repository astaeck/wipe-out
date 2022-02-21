//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI
import Photos


class SimilarAssetsViewModel: ObservableObject {
    
    func groupSimilarAssets(cards: [Card]) -> [SimilarCollection] {
        let groupedCards = Dictionary(grouping: cards.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        
        let similarCollection = similarGroupedCards.map { SimilarCollection(cards: $0) }
        return similarCollection
    }
}

class BestShotViewModel {
    private var collection: SimilarCollection
    
    init(collection: SimilarCollection) {
        self.collection = collection
    }

    func cardsToCompare(collection: SimilarCollection) -> [Card] {
        return Array(collection.cards.prefix(2))
    }
}
