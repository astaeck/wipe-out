//
//  AssetGrid.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct AssetGrid: View {
    @State var collection: SimilarCollection
    
    let layout = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout, spacing: 5) {
                ForEach(collection.cards) { card in
                    AssetGridItem(imageLoader: ImageLoadable(card: card), card: card)
                }
            }
            .frame(height: 200)
            .padding(.vertical)
        }
    }
}
