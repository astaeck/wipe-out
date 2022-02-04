//
//  SelectedAssetsGridView.swift
//  Photo Tinder
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
        ScrollView {
            LazyVGrid(columns: layout, spacing: 5) {
                ForEach(viewModel.cards.filter({ $0.isSelected }).indices) { index in
                    AsssetGridItem(index: index)
                }
                .cornerRadius(8)
                .padding(10)
            }
        }
        .padding([.horizontal, .top])
        .navigationTitle("\(viewModel.cards.filter({ $0.isSelected }).count) Selected")
        .toolbar {
            Button("Deselect All", action: viewModel.resetAll)
        }
    }
}
