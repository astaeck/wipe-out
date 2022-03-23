//
//  SimilarAssetGrid.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct SimilarAssetGrid: View {
    @State var collection: SimilarCollection
    @EnvironmentObject var viewModel: CardsViewModel
    @State private var showingSheet = false
    
    let layout = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        Button("Pick Best") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards), showModal: self.$showingSheet)
        }
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout, spacing: 5) {
                ForEach(collection.cards) { card in
                    AsssetGridItem(card: card)
                }
                .cornerRadius(8)
                .padding(5)
            }
            .frame(height: 200)
            .padding(.vertical)
        }
        
    }
}
