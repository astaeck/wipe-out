//
//  SimilarAssetsGridView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 23.06.22.
//

import SwiftUI

struct SimilarAssetsGridView: View {
    let collection: SimilarCollection
    
    var body: some View {
        VStack(alignment: .leading) {
            AssetGrid(collection: collection)
            HStack {
                Button("Deselect All") {
                    _ = collection.cards.map({ $0.isPreSelected = false })
                }
                .buttonStyle(.bordered)
                Button("Move to Trash") {
                    let cards = collection.cards.filter({ $0.isPreSelected })
                    cards.forEach { $0.isSelected = true }
                    collection.cards = collection.cards.filter({ !$0.isSelected })
                }
                .buttonStyle(.bordered)
            }
            .buttonStyle(.bordered)
            Spacer()
        }
    }
}
