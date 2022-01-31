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
            TabView {
               CardStackView()
                 .tabItem {
                    Image(systemName: "phone.fill")
                    Text("First Tab")
               }
                CardStackView()
                 .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Second Tab")
              }
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
