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
                    Section(header: Text("Screenshots").font(.headline)) {
                        ForEach(viewModel.screenshotCollections) { collection in
                            AssetGrid(collection: collection)
                            HStack {
                                Button("Deselect All") {
                                    _ = collection.cards.map({ $0.isPreSelected = false })
                                }
                                .buttonStyle(.bordered)
                                Button("Move to trash") {
                                    let cards = collections.first(where: { $0.id == collection.id }).cards.filter({ $0.isPreSelected })
                                    cards.forEach { $0.isSelected = true }
                                    collections.forEach({ $0.cards = $0.cards.filter({ $0.isSelected }) })
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    Section(header: Text("Similar Photos").font(.headline)) {
                        ForEach(viewModel.similarCollections) { collection in
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
