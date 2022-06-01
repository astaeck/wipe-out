//
//  CardsSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI

struct CardsSection: View {
    @EnvironmentObject var viewModel: CardsViewModel

    var body: some View {
        AsyncContentView(source: viewModel) { cards in
            ZStack{
                ForEach(cards) { card in
                    CardView(card: card,
                             imageLoader: ImageLoadable(card: card),
                             videoLoader: VideoLoader(asset: card.asset))
                }
            }
        }
    }
}
