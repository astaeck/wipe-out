//
//  SimiliarAssetsView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    private let screenshotLoader = ScreenshotLoader()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Screenshots").font(.headline)) {
                        ForEach(screenshotLoader.collectionsWith(viewModel.cards)) { collection in
                            AssetGrid(collection: collection)
                            Button("Deselect All") {
                                screenshotLoader.deselectCardsIn(collection)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .listRowSeparator(.hidden)
                    Section(header: Text("Similar Photos").font(.headline)) {
                        ForEach(SimilarAssetsLoader.collectionsWith(viewModel.cards)) { collection in
                            SimilarAssetsGridView(collection: collection)
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
