//
//  SimiliarAssetsView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 03.02.22.
//

import SwiftUI

struct SimilarAssetsView: View {
    @ObservedObject var viewModel: SimilarAssetsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Text("Screenshots").font(.headline)
                            .padding([.top])
                        AsyncContentView(source: viewModel) { collections in
                            ForEach(collections.filter({ $0.collectionType == .screenshot })) { collection in
                                AssetGridView(collection: collection)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)

                    Section {
                        Text("Similar Photos").font(.headline)
                            .padding([.top])
                        AsyncContentView(source: viewModel) { collections in
                            ForEach(collections.filter({ $0.collectionType == .similar })) { collection in
                                NavigationLink(destination: BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards))) {
                                    AssetGridView(collection: collection)
                                }
                                .padding([.top])
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .background(Color(UIColor.clear))
            .navigationTitle("Clean Up!")
            .toolbar {
                // TODO: Replace later
                //                Button("Delete Selection", action: viewModel.deleteAssets)
            }
        }
    }
}
