//
//  SimiliarAssetsView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    Section(header: Text("Screenshots")) {
                        AsyncContentView(source: ScreenshotLoader(cards: viewModel.cards)) { collections in
                            ForEach(collections) { collection in
                                AssetGrid(collection: collection)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    Section(header: Text("Similar Photos")) {
                        AsyncContentView(source: SimilarAssetsLoader(cards: viewModel.cards)) { collections in
                            ForEach(collections) { collection in
                                SimilarAssetsGridView(collection: collection)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Clean up!")
                .toolbar {
                    Button("Delete Selection", action: viewModel.deleteAssets)
                }
            }
        }
    }
}
