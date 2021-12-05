//
//  SelectedAssetsGridView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.12.21.
//

import SwiftUI
import Photos

struct SelectedAssetsGridView: View {
    @ObservedObject var viewModel: CardsViewModel
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 10) {
                    ForEach(viewModel.cardsToDelete) { card in
                        AsyncContentView(source: ImageLoader(asset: card.asset)) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 200)
                                .mask(RoundedRectangle(cornerRadius: 16))
                        }
                        .gesture (
                            TapGesture(count: 1).onEnded {
                                viewModel.resetSelectedCard(withID: card.id)
                            }
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Selected for deletion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Deselect all", action: viewModel.resetAll)
            }
        }
    }
}
