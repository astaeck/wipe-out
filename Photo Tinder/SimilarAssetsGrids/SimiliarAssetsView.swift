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
        AsyncContentView(source: viewModel) { _ in
            ZStack {
                ScrollView {
                    AsyncContentView(source: SimilarAssetsViewModel(viewModel: viewModel)) { collections in
                        VStack {
                            ForEach(collections) { collection in
                                SimilarAssetGrid(collection: collection)
                            }
                        }
                    }
                }
            }
        }
    }
}
