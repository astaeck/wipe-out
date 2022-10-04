//
//  CardStackViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 29.09.22.
//

import SwiftUI

final class CardStackViewModel: LoadableObject {
    
    typealias Output = [Card]
    @Published var state: LoadingState<[Card]> = .idle

    private var paginationIndex = 25
    private(set) var cards: [Card]

    init(cards: [Card]) {
        self.cards = cards

        load()
    }
    
    func load() {
        var cardsToDisplay = [Card]()
        if cards.count < paginationIndex {
            cardsToDisplay = cards
        } else {
            cardsToDisplay = (0..<paginationIndex).map { cards[$0] }
        }
        cardsToDisplay.first?.isEnabled = true
        state = .loaded(cardsToDisplay.reversed())
    }
    
    var numberOfAssets: Int {
        cards.count
    }
    
    func handleSwipe(forCard card: Card) {
        guard var index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if card.x < 0 {
            let card = cards[index]
            card.isSelected = true
            card.isPreSelected = true
        }
        index += 1
        
        guard index < paginationIndex else {
            loadMoreCards()
            return
        }
        
        if index < cards.count && (card.x < 0 || card.x > 0) {
            let nextCard = cards[index]
            nextCard.isEnabled = true
        }
    }
    
    func moveCardToTrashFrom(_ collection: SimilarCollection) {
        let cards = collection.cards.filter({ $0.isPreSelected })
        cards.forEach { $0.isSelected = true }
        
    }
    
    func setCardStackToDate(with date: Date) {
        guard let indexFromDate = cards.firstIndex(where: { Calendar.current.isDate($0.asset.creationDate!, equalTo: date, toGranularity: .day) }) else { return }
        
        paginationIndex = indexFromDate
        loadMoreCards()
    }
    
    // MARK: - Private
    
    private func loadMoreCards() {
        let newCards = (paginationIndex..<paginationIndex + 25).map { cards[$0] }
        paginationIndex += 25
        newCards.first?.isEnabled = true
        state = .loaded(newCards.reversed())
    }
}
