//
//  ContentView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 23.11.21.
//

import SwiftUI
import Photos

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack {
                CardsSection()
                .padding()
                .zIndex(1.0)
                FooterSection()
            }
            .navigationTitle("All Photos")
            .toolbar {
                NavigationLink("Show selected", destination: SelectedAssetsGridView())
            }
        }
        .environmentObject(CardsViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardsViewModel())
    }
}
