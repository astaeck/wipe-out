//
//  FooterSection.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 28.11.21.
//

import SwiftUI

struct FooterSection: View {
    @StateObject var viewModel: CardsViewModel

    var body: some View {
        HStack() {
            Button(action: viewModel.deleteAssets) {
                Text("Delete")
            }
            Spacer()
            Button(action: viewModel.resetSelection) {
                Text("Reset")
            }
        }.padding([.horizontal, .bottom])
    }
}

struct FooterSection_Previews: PreviewProvider {
    static var previews: some View {
        FooterSection(viewModel: CardsViewModel())
    }
}
