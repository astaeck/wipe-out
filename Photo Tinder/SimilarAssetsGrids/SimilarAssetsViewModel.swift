//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI
import Photos

class SimilarAssetsViewModel: LoadableObject {
    @ObservedObject var viewModel: CardsViewModel

    typealias Output = [SimilarCollection]
    @Published private(set) var state: LoadingState<[SimilarCollection]> = .idle
    private var similarCollection: [SimilarCollection] = []
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
    }

    func load() {
        groupSimilarAssets()
    }
    
    private func groupSimilarAssets() {
        let groupedAssets = Dictionary(grouping: viewModel.newCards.map { $0.asset }) { asset -> DateComponents in
            return Calendar.current.dateComponents([.minute, .day, .year, .month], from: (asset.creationDate)!)
        }
        let similarGroupedAssets = groupedAssets.values.filter { $0.count > 2 }
        
        similarCollection = similarGroupedAssets.map { SimilarCollection(cards: $0.map { Card(asset: $0) }) }
        DispatchQueue.main.async {
            self.state = .loaded(self.similarCollection)
            print(similarGroupedAssets)
        }
    }
}
