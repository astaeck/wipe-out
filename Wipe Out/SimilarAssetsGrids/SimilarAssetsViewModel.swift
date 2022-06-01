//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI
import Photos


class SimilarAssetsViewModel: ObservableObject {
    @Published var collections: [SimilarCollection] = []

    func fetchData(cards: [Card]) async {
        let groupedCards = Dictionary(grouping: cards.map { $0 }) { card -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (card.asset.creationDate)!)
        }
        let similarGroupedCards = groupedCards.values.filter { $0.count > 2 }
        
        collections = similarGroupedCards.map { SimilarCollection(cards: $0) }
    }
}