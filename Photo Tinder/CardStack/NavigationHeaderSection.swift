//
//  NavigationHeaderSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 12.12.21.
//

import SwiftUI

struct NavigationHeaderSection: View {
    @EnvironmentObject var viewModel: CardsViewModel

    var body: some View {
        HStack {
            Text("\(viewModel.numberOfAssets)").font(.headline)
                .padding(.top)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink("🗑", destination: SelectedAssetsGridView())
            }
        }
        .navigationTitle("All Photos")
    }
}
