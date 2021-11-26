//
//  CardsSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI

struct CardsSection: View {
    @StateObject var viewModel: CardsViewModel

    var body: some View {
        ZStack{
            ForEach(viewModel.cards.reversed()) { card in
                CardView(card: card, imageLoader: ImageLoader(asset: card.asset))
            }
        }
        .onAppear {
            viewModel.fetchAssets()
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
