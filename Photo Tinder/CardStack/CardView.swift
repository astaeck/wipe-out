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
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    @ObservedObject var card: Card
    private let imageLoader: ImageLoadable
    @ObservedObject var videoLoader: VideoLoader
    @ObservedObject var locationLoader: LocationLoadable
    @EnvironmentObject var viewModel: CardsViewModel
    @State var labelIsVisible: Bool = true
    @State var scale: CGFloat = 1.0
    
    init(card: Card) {
        self.card = card
        self.imageLoader = ImageLoadable(card: card)
        self.videoLoader = VideoLoader(asset: card.asset)
        self.locationLoader = LocationLoadable(card: card)
    }

    var body: some View {
        let swipeGesture = DragGesture()
            .onChanged { value in
                withAnimation(.default) {
                    card.x = value.translation.width
                    card.y = value.translation.height
                    card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                    labelIsVisible = card.x == 0
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
                    labelIsVisible = true
                }
                viewModel.handleSwipe(forCard: card)
            }
        
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                self.scale = value.magnitude
            }
            .onEnded { val in
                withAnimation {
                    self.scale = 1.0
                }
            }
        
        let swipeBeforeMagnificationGesture = swipeGesture.exclusively(before: magnificationGesture)
        
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    Spacer()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color(UIColor.systemBackground))
                        .opacity(labelIsVisible ? 1.0 : 0.0)
                    
                    VStack {
                        VStack {
                            AsyncContentView(source: locationLoader) { locationName in
                                Text(locationName)
                            }
                            if let date = card.asset.creationDate {
                                Text("\(date, formatter: Self.dateFormat)")
                            }
                        }
                        .opacity(labelIsVisible ? 1.0 : 0.0)
                        
                        ZStack {
                            if card.asset.mediaType == .video {
                                AsyncContentView(source: videoLoader) { videoURL in
                                    VideoPlayer(player: AVPlayer(url: videoURL.url))
                                        .clipped()
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                }
                            }
                            AsyncContentView(source: imageLoader) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .opacity(labelIsVisible && card.asset.mediaType == .video ? 0.0 : 1.0)
                            }
                        }
                    }
                }
            }
            .scaleEffect(scale)
            .zIndex(1.0)
            
            ZStack {
                Text("✅")
                    .opacity(Double(card.x/10 - 1))
                Spacer()
                Text("❌")
                    .opacity(Double(card.x/10 * -1 - 1))
            }
        }
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture(card.isEnabled ? swipeBeforeMagnificationGesture : nil)
    }
}
