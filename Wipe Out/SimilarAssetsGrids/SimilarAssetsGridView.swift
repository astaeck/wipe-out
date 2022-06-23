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
        NavigationLink(destination: BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards))) {
            AssetGrid(collection: collection)
        }
        Button("Deselect All") {
            _ = collection.cards.map({ $0.isSelected = false })
        }
        .buttonStyle(.bordered)
        Spacer()
    }
}
