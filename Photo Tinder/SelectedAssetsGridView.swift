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

    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 5) {
                ForEach(viewModel.cards.filter({ $0.isSelected })) { card in
                    ZStack {
                        AsyncContentView(source: ImageLoader(asset: card.asset)) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 200)
                                .clipped()
                            
                        }
                        LinearGradient(gradient: cardGradient, startPoint: .top, endPoint: .bottom)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("☑️")
                                    .opacity(card.isSelected ? 1.0 : 0.0)
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                    }
                    .gesture (
                        TapGesture(count: 1).onEnded {
                            viewModel.resetSelectedCard(withID: card.id)
                        }
                    )
                }
                .cornerRadius(8)
                .padding(10)
            }
        }
        .padding([.horizontal, .top])
        .navigationTitle("Selection")
        .toolbar {
            Button("Deselect All", action: viewModel.resetAll)
        }
    }
}
