//
//  CardStackView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 31.01.22.
//
import SwiftUI

struct CardStackView: View {
    var body: some View {
        VStack {
            NavigationHeaderSection()
            .padding(.horizontal)
            CardsSection()
            .padding()
            .zIndex(1.0)
            FooterSection()
            Spacer()
        }
    }
}
