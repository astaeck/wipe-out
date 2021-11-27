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
        AsyncContentView(source: viewModel) { cards in
            ZStack{
                ForEach(cards.reversed()) { card in
                    CardView(card: card,
                             imageLoader: ImageLoader(asset: card.asset),
                             videoLoader: VideoLoader(asset: card.asset))
                }
            }
        }
    }
}

struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection(viewModel: CardsViewModel())
    }
}
