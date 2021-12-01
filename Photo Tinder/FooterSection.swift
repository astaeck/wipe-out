//
//  FooterSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 28.11.21.
//

import SwiftUI

struct FooterSection: View {
    @ObservedObject var viewModel: CardsViewModel

    var body: some View {
        HStack() {
            Button("Delete", action: viewModel.deleteAssets)
                .buttonStyle(CustomButtonStyle())
            Spacer()
            Button("Reset", action: viewModel.resetSelection)
              .buttonStyle(CustomButtonStyle())
        }.padding([.horizontal, .bottom])
    }
}

struct FooterSection_Previews: PreviewProvider {
    static var previews: some View {
        FooterSection(viewModel: CardsViewModel())
    }
}
