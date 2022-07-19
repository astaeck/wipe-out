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
                    Text("Screenshots").font(.headline)
                    ForEach(viewModel.similarCollections.filter({ $0.collectionType == .screenshot })) { collection in
                        Section {
                            AssetGridView(collection: collection)
                        }
                    }
                    Text("Similar Photos").font(.headline)
                    ForEach(viewModel.similarCollections.filter({ $0.collectionType == .similar })) { collection in
                        Section {
                            NavigationLink(destination: BestShotPickerView(viewModel: BestShotViewModel(similarCards: collection.cards))) {
                                AssetGridView(collection: collection)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.insetGrouped)
            .background(Color(UIColor.clear))
            .navigationTitle("Clean Up!")
            .toolbar {
                Button("Delete Selection", action: viewModel.deleteAssets)
            }
        }
    }
}
