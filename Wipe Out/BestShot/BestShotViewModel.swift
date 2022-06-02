//
//  BestShotViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 05.03.22.
//
import SwiftUI

class BestShotViewModel: ObservableObject {
    @Published private var cardToKeep: Card?
    private var cardsToCompare: [Card] = []
    private let similarCards: [Card]
    
    init(similarCards: [Card]) {
        self.similarCards = similarCards
    }
    
    func compareCards() -> [Card] {
        cardsToCompare = Array(similarCards.filter({ $0.isSelected == false }).prefix(2))
        return cardsToCompare
    }
    
    func keepSelectedCard(_ card: Card) {
        cardsToCompare.first(where: { $0.id != card.id })?.isSelected = true
        card.isSelected = false
        cardToKeep = card
    }
    
}
