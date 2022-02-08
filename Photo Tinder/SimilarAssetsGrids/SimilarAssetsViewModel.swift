//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI
import Photos

class SimilarAssetsViewModel: ObservableObject {

    @Published private var similarCollection: [SimilarCollection] = []
    
    func groupSimilarAssets(cards: [Card]) -> [SimilarCollection] {
        let groupedAssets = Dictionary(grouping: cards.map { $0.asset }) { asset -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (asset.creationDate)!)
        }
        let similarGroupedAssets = groupedAssets.values.filter { $0.count > 2 }
        
        let similarCollection = similarGroupedAssets.map { SimilarCollection(cards: $0.map { Card(asset: $0) }) }
        return similarCollection
    }
    
    func refresh() {
        
    }
}
