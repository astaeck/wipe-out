//
//  CardsSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI

struct CardsSection: View {
    @ObservedObject var viewModel: CardsViewModel

    var body: some View {
        ZStack{
            ForEach(viewModel.cards) { card in
                CardView(card: card, imageLoader: ImageLoader(asset: card.asset))
            }
        }
        .onAppear {
            viewModel.fetchPhotos()
        }
        .padding(8)
        
        .zIndex(1.0)
    }
}

struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection(viewModel: CardsViewModel())
    }
}
