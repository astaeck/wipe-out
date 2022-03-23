//
//  BestShotPickerView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 19.02.22.
//

import SwiftUI

struct BestShotPickerView: View {
    @ObservedObject private var viewModel: BestShotViewModel
    @State private var showDetails = false
    
    init(viewModel: BestShotViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List(viewModel.cardsToCompare()) { card in
                AsyncContentView(source: ImageLoadable(card: card)) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 350)
                }
                .gesture(TapGesture(count: 1).onEnded {
                    withAnimation(.easeOut) {
                        viewModel.keepSelectedCard(card)
                    }
                })
            }
        }
        .onAppear {
            viewModel.setUp()
        }
    }
}
