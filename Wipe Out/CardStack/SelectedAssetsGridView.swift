//
//  SelectedAssetsGridView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 01.12.21.
//

import SwiftUI
import Photos

struct SelectedAssetsGridView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        List {
            LazyVGrid(columns: layout, spacing: 5) {
                ForEach(viewModel.cards.filter({ $0.isSelected })) { card in
                    AssetGridItem(imageLoader: ImageLoadable(card: card), card: card)
                }
                .cornerRadius(8)
                .padding(10)
            }
            .listRowSeparator(.hidden)
        }
        .animation(.default, value: viewModel.cards.filter({ $0.isSelected }))
        .listStyle(.plain)
        .padding([.horizontal, .top])
        .navigationTitle("\(viewModel.cards.filter({ $0.isSelected }).count) Selected")
        .toolbar {
            Button("Wipe out all", action: viewModel.deleteAssets)
        }
    }
}
