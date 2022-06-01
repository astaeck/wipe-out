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
        NavigationView {
            VStack {
                List(similarAssetsViewModel.collections) { collection in
                    SimilarAssetGrid(collection: collection)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Similar Photos")
                .toolbar {
                    Button("Delete Selection", action: viewModel.deleteAssets)
                }
                .task {
                    await similarAssetsViewModel.fetchData(cards: viewModel.cards)
                }
            }
        }
    }
}
