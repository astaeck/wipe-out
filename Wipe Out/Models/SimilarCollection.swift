//
//  SimilarCollection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 03.02.22.
//
import SwiftUI

enum CollectionType {
    case screenshot
    case similar
}

class SimilarCollection: ObservableObject, Identifiable {
    let id = UUID()
    let collectionType: CollectionType
    @Published var cards: [Card]
    
    init(cards: [Card],
         collectionType: CollectionType) {
        self.cards = cards
        self.collectionType = collectionType
    }
    
    func removeCardsFromCollections(_ cardsToDelete: [Card]) {
       cards = cards.filter({ card in !cardsToDelete.contains(card) })
    }
}
