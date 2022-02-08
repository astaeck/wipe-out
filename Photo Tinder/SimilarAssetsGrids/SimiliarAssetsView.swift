//
//  SimiliarAssetsView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    @StateObject var similarAssetsViewModel = SimilarAssetsViewModel()
        
    var body: some View {
        List(similarAssetsViewModel.groupSimilarAssets(cards: viewModel.cards)) { collection in
            SimilarAssetGrid(collection: collection)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
