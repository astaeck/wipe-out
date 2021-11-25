//
//  ContentView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 23.11.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardsSection(viewModel: CardsViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
