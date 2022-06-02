//
//  BestShotPickerView.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 19.02.22.
//

import SwiftUI

struct BestShotPickerView: View {
    @ObservedObject var viewModel: BestShotViewModel
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showModal.toggle()
                }, label: {
                    Image("arrow-down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                    .frame(width: 32, height: 32)
                    .padding([.leading, .top])
                Spacer()
            }
            List(viewModel.compareCards()) { card in
                HStack {
                    Spacer()
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
                        viewModel.keepSelectedCard(card)
                    })
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
            .animation(.default, value: viewModel.compareCards())
            .listStyle(.plain)
        }
    }
}
