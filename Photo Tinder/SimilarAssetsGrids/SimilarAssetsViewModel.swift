//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

class SimilarAssetsViewModel: LoadableObject {
    typealias Output = [SimilarCollection]
    @Published private(set) var state: LoadingState<[SimilarCollection]> = .idle

    private let cards: [Card]
    
    init(cards: [Card]) {
        self.cards = cards
    }

    func load() {        
        state = .loaded([SimilarCollection(cards: [cards[0], cards[1], cards[2]])])
    }
}
