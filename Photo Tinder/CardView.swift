//
//  CardView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI
import Combine
import Photos
import AVKit

struct CardView: View {
    @State var card: Card
    @ObservedObject var imageLoader: ImageLoader
    @ObservedObject var videoLoader: VideoLoader
    
    var body: some View {
        ZStack(alignment: .center) {
            if card.asset.mediaType == .video {
                AsyncContentView(source: videoLoader) { videoURL in
                    VideoPlayer(player: AVPlayer(url: videoURL.url))
                        .frame(width: 300, height: 400)
                        .clipped()
                        .cornerRadius(8)
                        .padding()
                        .foregroundColor(.white)
                }
            } else {
                AsyncContentView(source: imageLoader) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 400)
                        .clipped()
                        .cornerRadius(8)
                        .padding()
                        .foregroundColor(.white)
                }
            }
            
            HStack {
                Image("yes")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:150)
                    .opacity(Double(card.x/10 - 1))
                Spacer()
                Image("nope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:150)
                    .opacity(Double(card.x/10 * -1 - 1))
            }
            
        }
        
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture (
            DragGesture()
                .onChanged { value in
                    withAnimation(.default) {
                        card.x = value.translation.width
                        // MARK: - BUG 5
                        card.y = value.translation.height
                        card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                    }
                }
                .onEnded { (value) in
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                        switch value.translation.width {
                        case 0...100:
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x > 100:
                            card.x = 500; card.degree = 12
                        case (-100)...(-1):
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x < -100:
                            card.x  = -500; card.degree = -12
                        default:
                            card.x = 0; card.y = 0
                        }
                    }
                }
        )
    }
}

