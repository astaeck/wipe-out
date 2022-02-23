//
//  BestShotPickerView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 19.02.22.
//

import SwiftUI
import UIKit

struct BestShotPickerView: View {
    let collection: SimilarCollection
    private let viewModel: BestShotViewModel

    init(collection: SimilarCollection) {
        self.collection = collection
        self.viewModel = BestShotViewModel(collection: collection)
    }

    var body: some View {
        VStack {
            List(viewModel.cardsToCompare(collection: collection)) { card in
                AsyncContentView(source: ImageLoadable(card: card)) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
