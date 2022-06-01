//
//  AsssetGridItem.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import SwiftUI

struct AsssetGridItem: View {
    @EnvironmentObject var viewModel: CardsViewModel
    private let imageLoader: ImageLoadable
    var card: Card
    @State var isSelected: Bool = false
    
    init(card: Card) {
        self.card = card
        self.imageLoader = ImageLoadable(card: card)
    }

    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])

    var body: some View {
        ZStack {
            AsyncContentView(source: imageLoader) { image in
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
                        .opacity(isSelected ? 1.0 : 0.0)
                }
            }
            .padding()
            .foregroundColor(.white)
        }
        .onTapGesture {
            isSelected = !isSelected
            card.isSelected = !isSelected
            viewModel.updateSelection(card: card)
        }
    }
}