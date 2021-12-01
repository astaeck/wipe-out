//
//  SelectedAssetsGridView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.12.21.
//

import SwiftUI
import Photos

struct SelectedCardsView: View {
    let assets: [PHAsset]
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 10) {
                ForEach(assets, id: \.self) { asset in
                    AsyncContentView(source: ImageLoader(asset: asset)) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .mask(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
