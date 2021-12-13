//
//  SubtitleSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 12.12.21.
//

import SwiftUI

struct SubtitleSection: View {
    @EnvironmentObject var viewModel: CardsViewModel

    var body: some View {
        HStack {
            Text("\(viewModel.cards.count)").font(.headline)
            Spacer()
        }
    }
}
