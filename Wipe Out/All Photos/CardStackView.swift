//
//  CardStackView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 31.01.22.
//
import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var viewModel: CardsViewModel

    var body: some View {
        NavigationView {
            VStack {
                CardsSection()
                .padding()
                .zIndex(1.0)
                FooterSection()
                Spacer()
            }
            .navigationTitle("All Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("🗑", destination: SelectedAssetsGridView())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("\(viewModel.numberOfAssets)").font(.headline)
                }
            }
        }
    }
}
