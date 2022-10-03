//
//  CardStackView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 31.01.22.
//
import SwiftUI

struct CardStackView: View {
    @ObservedObject var viewModel: CardStackViewModel

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TimePeriodPicker(viewModel: viewModel)
                CardsSection(viewModel: viewModel)
                .zIndex(1.0)
                FooterSection(viewModel: viewModel)
            }
            .navigationTitle("All Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("🗑", destination: SelectedAssetsGridView(viewModel: viewModel))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("\(viewModel.numberOfAssets)").font(.headline)
                }
            }
        }
    }
}
