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
            CardStackView()
                .tabItem {
                    Image(systemName: "rectangle.on.rectangle")
                    Text("All Photos")
                }
            SimilarAssetsView()
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Similar Photos")
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
