//
//  NavigationHeaderSection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 12.12.21.
//

import SwiftUI

struct NavigationHeaderSection: View {
    @EnvironmentObject var viewModel: CardsViewModel

    var body: some View {
        HStack {
            Text("\(viewModel.numberOfAssets)").font(.headline)
            Spacer()
        }
        .navigationTitle("All Photos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink("🗑", destination: SelectedAssetsGridView())
            }
        }
    }
}
