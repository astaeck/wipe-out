//
//  SimilarAssetGrid.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct SimilarAssetGrid: View {
    @EnvironmentObject var viewModel: SimilarAssetsViewModel

    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 5) {
//                ForEach(viewModel.cards.filter({ $0.isSelected }).indices) { index in
//                    AsssetGridItem(index: index)
//                }
//                .cornerRadius(8)
//                .padding(10)
            }
        }
        .padding([.horizontal, .top])
        .navigationTitle("0 Selected")
        .toolbar {
//            Button("Deselect All", action: viewModel.resetAll)
        }
    }
}
