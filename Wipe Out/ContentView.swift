//
//  ContentView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 23.11.21.
//

import SwiftUI
import Photos

struct ContentView: View {
    private let cardsViewModel: CardsViewModel = CardsViewModel()

    var body: some View {
        
        TabView {
            AsyncContentView(source: cardsViewModel) { cards in
                CardStackView(viewModel: CardStackViewModel(cards: cards))
                    .tabItem {
                        Image(systemName: "rectangle.on.rectangle")
                        Text("All Photos")
                    }
                SimilarAssetsView(viewModel: SimilarAssetsViewModel(cards: cards))
                    .tabItem {
                        Image(systemName: "photo.fill")
                        Text("Clean Up")
                    }
            }
        }
        .environmentObject(cardsViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardsViewModel())
    }
}
