//
//  SimilarAssetsViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 28.09.22.
//

import SwiftUI

final class SimilarAssetsViewModel: LoadableObject {
    
    typealias Output = [SimilarCollection]
    
    @Published private(set) var state: LoadingState<[SimilarCollection]> = .idle

    private let cards: [Card]
    private var similarCollections: [SimilarCollection] = []

    init(cards: [Card]) {
        self.cards = cards
        
        load()
    }
    
    func load() {
        loadScreenshotCollections()
        loadSimilarCollections()
    }
    
    private func loadScreenshotCollections() {
        let screenshots: [Card] = cards.filter { $0.asset.mediaSubtypes.contains(.photoScreenshot) }
        screenshots.forEach { $0.isPreSelected = true }
        similarCollections.append(contentsOf: [SimilarCollection(cards: screenshots, collectionType: .screenshot)])
        state = .loaded(similarCollections)
    }

    private func loadSimilarCollections() {
        let cardsWithoutVideos = cards.filter { $0.asset.mediaType != .video }
        let cardsWithoutScreenshots = cardsWithoutVideos.filter { !$0.asset.mediaSubtypes.contains(.photoScreenshot) }
        let groupedCards = Dictionary(grouping: cardsWithoutScreenshots.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        similarCollections.append(contentsOf: similarGroupedCards.map { SimilarCollection(cards: $0, collectionType: .similar) })
        state = .loaded(similarCollections)
    }
    
    private func removeCardFromCollections(_ deletedCards: [Card]) {
        similarCollections.forEach({ $0.removeCardsFromCollections(deletedCards) })
    }
    
    private func updateCollectionsWith(_ card: Card) {
        similarCollections.forEach({ $0.cards = $0.cards })
    }
    
}
