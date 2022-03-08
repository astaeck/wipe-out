//
//  BestShotViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 05.03.22.
//
import SwiftUI

class BestShotViewModel: ObservableObject {
    private let similarCards: [Card]
    @Published private var cardToKeep: Card?
    @Published private var leftCards: [Card] = []
    
    init(similarCards: [Card]) {
        self.similarCards = similarCards
    }
    
    func cardsToCompare() -> [Card] {
        if let cardToKeep = cardToKeep {
            guard !leftCards.isEmpty,
                  let firstCard = leftCards.first else { return [cardToKeep] }
            return [cardToKeep, firstCard]
        }
        return Array(similarCards.prefix(2))
    }
    
    func keepSelectedCard(_ card: Card) {
        guard !leftCards.isEmpty else { return }
        cardToKeep = card
        if let index = leftCards.firstIndex(where: { $0.id == card.id }) {
            leftCards.remove(at: index)
        }
        guard !leftCards.isEmpty else { return }
        leftCards.removeFirst()
    }
    
    func setUp() {
        cardToKeep = nil
        leftCards = similarCards
    }
}
