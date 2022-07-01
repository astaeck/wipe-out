//
//  SimilarAssetCollection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 03.02.22.
//
import SwiftUI

class SimilarCollection: ObservableObject, Identifiable {
    let id = UUID()
    @Published var cards: [Card]
    
    init(cards: [Card]) {
        self.cards = cards
    }
}
