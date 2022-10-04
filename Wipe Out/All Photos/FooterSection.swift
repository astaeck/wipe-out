//
//  FooterSection.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 28.11.21.
//

import SwiftUI

struct FooterSection: View {
    @EnvironmentObject var cardsViewModel: CardsViewModel

    var body: some View {
        HStack() {
            Button("Delete", action: cardsViewModel.deleteCards)
                .buttonStyle(CustomButtonStyle())
            Spacer()
            Button("Reset last", action: cardsViewModel.resetLast)
              .buttonStyle(CustomButtonStyle())
        }.padding([.horizontal, .bottom])
    }
}
