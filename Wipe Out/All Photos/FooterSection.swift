//
//  FooterSection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 28.11.21.
//

import SwiftUI

struct FooterSection: View {
    @ObservedObject var viewModel: CardStackViewModel

    var body: some View {
        HStack() {
            Button("Delete", action: viewModel.deleteAssets)
                .buttonStyle(CustomButtonStyle())
            Spacer()
            Button("Reset last", action: viewModel.resetLast)
              .buttonStyle(CustomButtonStyle())
        }.padding([.horizontal, .bottom])
    }
}
