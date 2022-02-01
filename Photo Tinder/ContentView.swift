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
                    Image(systemName: "photo.fill")
                    Text("All Photos")
               }
                SimilarAssetGrid()
                 .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Similar Photos")
              }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("🗑", destination: SelectedAssetsGridView())
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
