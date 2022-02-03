//
//  SimilarAssetGrid.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct SimilarAssetGrid: View {
    @State var collection: SimilarCollection
    
    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    let layout = [
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyHGrid(rows: layout) {
                ForEach(collection.cards.indices) { index in
                    AsssetGridItem(index: index)
                }
                .cornerRadius(8)
                .padding(10)
            }
        }
        .padding([.horizontal, .top])
        .navigationTitle("0 Selected")
        .toolbar {
            //            Button("Deselect All", action: viewModel.resetAll)
        }
    }
}
