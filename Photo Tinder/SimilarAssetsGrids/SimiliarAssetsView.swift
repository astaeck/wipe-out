//
//  SimiliarAssetsView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    
    var body: some View {
        AsyncContentView(source: viewModel) { cards in
            ZStack {
                AsyncContentView(source: SimilarAssetsViewModel(cards: cards)) { collections in
                    ZStack{
                        ForEach(collections) { collection in
                            SimilarAssetGrid(collection: collection)
                        }
                    }
                }
            }
        }
    }
}

