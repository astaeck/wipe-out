//
//  CardsSection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI

struct CardsSection: View {
    @ObservedObject var viewModel: CardStackViewModel

    var body: some View {
        AsyncContentView(source: viewModel) { cards in
            ZStack {
                ForEach(cards) { card in
                    CardView(card: card,
                             imageLoader: ImageLoadable(card: card),
                             videoLoader: VideoLoader(asset: card.asset),
                             viewModel: viewModel)
                }
            }
        }
    }
}
