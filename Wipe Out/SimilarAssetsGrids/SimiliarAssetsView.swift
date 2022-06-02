//
//  SimiliarAssetsView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    let similarAssetsLoader: SimilarAssetsLoader
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncContentView(source: SimilarAssetsLoader(cards: viewModel.cards)) { collections in
                    List(collections) { collection in
                        SimilarAssetGrid(collection: collection)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle("Similar Photos")
                    .toolbar {
                        Button("Delete Selection", action: viewModel.deleteAssets)
                    }
                }
            }
        }
    }
}
