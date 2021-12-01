//
//  ContentView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 23.11.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            CardsSection(viewModel: CardsViewModel())
                .navigationTitle("Welcome")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    NavigationLink("Show selected", destination: EmptyView())
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
