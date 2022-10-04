//
//  CardsViewModel.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI

final class CardsViewModel: LoadableObject {
    
    typealias Output = [Card]
    @Published private(set) var state: LoadingState<[Card]> = .idle

    private let assetLoader: AssetLoader
    private var cards: [Card] = []

    init(assetLoader: AssetLoader = AssetLoader()) {
        self.assetLoader = assetLoader
    }
    
    func load() {
        state = .loading
        
        Task {
            do {
                let assets = try await assetLoader.fetch()
                cards = assets.map { Card(asset: $0) }
                await MainActor.run {
                    state = .loaded(cards)
                }
            }
            catch {
                await MainActor.run {
                    state = .failed("Couldn't load cards")
                }
            }
        }
    }
    
    func deleteCards() {
        let cardsToDelete = cards.filter { $0.isSelected }
        guard cardsToDelete.count != 0 else { return }
        let assetsToDelete = cardsToDelete.map { $0.asset }
        Task {
            do {
                let success = try await assetLoader.delete(assets: assetsToDelete)
                if success {
                    await MainActor.run {
                        cards = cards.filter { !cardsToDelete.contains($0) }
                        state = .loaded(cards)
                    }
                }
            }
            catch {
                await MainActor.run {
                    state = .failed("Couldn't delete cards")
                }
            }
        }
    }
    
    func resetLast() {
        guard let card = cards.reversed().first(where: { $0.x != 0 }) else { return }
        resetSelectedCard(withID: card.id)
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
    }
}
