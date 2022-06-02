//
//  SimilarAssetsLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 02.06.22.
//

import SwiftUI
import Photos


class SimilarAssetsLoader: LoadableObject {
    private let cards: [Card]
    typealias Output = [SimilarCollection]
    @Published private(set) var state: LoadingState<[SimilarCollection]> = .idle

    init(cards: [Card]) {
        self.cards = cards
    }

    func load() {
        let groupedCards = Dictionary(grouping: cards.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        
        state = .loaded(similarGroupedCards.map { SimilarCollection(cards: $0) })
    }
}
