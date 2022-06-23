//
//  SimilarAssetsGridView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 23.06.22.
//

import SwiftUI

struct SimilarAssetsGridView: View {
    @State private var showingSheet = false
    let collection: SimilarCollection
    
    var body: some View {
        VStack {
            Button("Pick Best") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards), showModal: self.$showingSheet)
            }
            AssetGrid(collection: collection)
        }
    }
}
