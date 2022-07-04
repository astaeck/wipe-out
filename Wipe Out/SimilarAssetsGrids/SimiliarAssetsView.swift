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
                            SimilarAssetsGridView(collection: collection)
                        }
                    }
                    .listRowSeparator(.hidden)
                    Section(header: Text("Similar Photos").font(.headline)) {
                        ForEach(viewModel.similarCollections) { collection in
                            NavigationLink(destination: BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards))) {
                                SimilarAssetsGridView(collection: collection)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle("Clean Up!")
                .toolbar {
                    Button("Delete Selection", action: viewModel.deleteAssets)
                }
            }
        }
    }
}
