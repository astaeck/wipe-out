//
//  CardStackViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 29.09.22.
//

import Photos

final class CardStackViewModel: LoadableObject {
    
    typealias Output = [Card]
    @Published var state: LoadingState<[Card]> = .idle

    private var paginationIndex = 25
    private(set) var cards: [Card]
    private let photoLibrary: PHPhotoLibrary

    init(cards: [Card],
         photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.cards = cards
        self.photoLibrary = photoLibrary

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
            // TODO: Replace later
            //            updateCollectionsWith(card) // state update
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
    
    func resetLast() {
        guard let card = cards.reversed().first(where: { $0.x != 0 }) else { return }
        resetSelectedCard(withID: card.id)
    }
    
    func deleteAssets() {
        let cardsToDelete = cards.filter { $0.isSelected }
        guard cardsToDelete.count != 0 else { return }
        let assetsToDelete = cardsToDelete.map { $0.asset }
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }, completionHandler: { success, _ in
            if success {
                DispatchQueue.main.async {
                    // TODO: Replace later
                    //                    self.removeCardFromCollections(cardsToDelete)
                    self.cards = self.cards.filter { $0.isSelected == false }
                    let newCards = (self.paginationIndex - 25..<self.paginationIndex).map { self.cards[$0] }
                    self.state = .loaded(newCards.reversed())
                }
            }
        })
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
    
    private func resetSelectedCard(withID id: UUID) {
        guard let index = cards.firstIndex(where: { $0.id == id }) else { return }
        let card = cards[index]
        card.x = 0
        card.y = 0
        card.degree = 0
        card.isSelected = false
        card.isPreSelected = false
        // TODO: Replace later
        //        updateCollectionsWith(card) // state update
    }
    
    private func loadMoreCards() {
        let newCards = (paginationIndex..<paginationIndex + 25).map { cards[$0] }
        paginationIndex += 25
        newCards.first?.isEnabled = true
        state = .loaded(newCards.reversed())
    }
}
