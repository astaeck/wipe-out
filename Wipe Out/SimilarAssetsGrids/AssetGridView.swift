//
//  AssetGridView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 23.06.22.
//

import SwiftUI

struct AssetGridView: View {
    @ObservedObject var collection: SimilarCollection
    
    let layout = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                LazyHGrid(rows: layout, spacing: 5) {
                    ForEach(collection.cards.filter({ !$0.isSelected })) { card in
                        AssetGridItem(imageLoader: ImageLoadable(card: card), card: card)
                    }
                }
                .frame(height: 200)
                .padding(.vertical)
            }
            HStack {
                Button("Deselect All") {
                    _ = collection.cards.map({ $0.isPreSelected = false })
                }
                .buttonStyle(.bordered)
                Button("Move to Trash") {
                    let cards = collection.cards.filter({ $0.isPreSelected })
                    cards.forEach { $0.isSelected = true }
                    collection.cards = collection.cards
                }
                .buttonStyle(.bordered)
            }
            .buttonStyle(.bordered)
            Spacer()
        }
    }
}
