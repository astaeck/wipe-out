//
//  ContentView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 23.11.21.
//

import SwiftUI
import Photos

struct ContentView: View {
    @ObservedObject var viewModel = CardsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                CardsSection(viewModel: viewModel)
                .padding()
                .zIndex(1.0)
                FooterSection(viewModel: viewModel)
            }
            .navigationTitle("All Photos")
            .toolbar {
                NavigationLink("Show selected", destination: SelectedAssetsGridView(viewModel: viewModel))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
