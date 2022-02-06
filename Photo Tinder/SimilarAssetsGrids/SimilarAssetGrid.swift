//
//  SimilarAssetGrid.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct SimilarAssetGrid: View {
    @State var collection: SimilarCollection
        
    let layout = [
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHGrid(rows: layout, spacing: 5) {
                    ForEach(collection.cards) { card in
                        AsssetGridItem(card: card)
                    }
                    .cornerRadius(8)
                    .padding(10)
                }
                .frame(height: 200)
            }
            Spacer()
        }
        .padding([.leading, .vertical])
        .navigationTitle("0 Selected")
        .toolbar {
            //            Button("Deselect All", action: viewModel.resetAll)
        }
    }
}
