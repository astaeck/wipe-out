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
    @ObservedObject var imageLoader: ImageLoader
    @ObservedObject var videoLoader: VideoLoader
    @ObservedObject var locationLoader: LocationLoader
    @EnvironmentObject var viewModel: CardsViewModel
    @State var labelIsVisible: Bool = true
    
    init(card: Card) {
        self.card = card
        self.imageLoader = ImageLoader(asset: card.asset)
        self.videoLoader = VideoLoader(asset: card.asset)
        self.locationLoader = LocationLoader(location: card.asset.location)
    }

    var body: some View {
        VStack {
            VStack {
                AsyncContentView(source: locationLoader) { locationName in
                    Text(locationName)
                }
                if let date = card.asset.creationDate {
                    Text("\(date, formatter: Self.dateFormat)")
                }
            }
            .frame(width: 300, height: 50)
            .background(Color(UIColor.systemBackground))
            .opacity(labelIsVisible ? 1.0 : 0.0)
            
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
            }
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
        .gesture (
            DragGesture()
                .onChanged { value in
                    withAnimation(.default) {
                        card.x = value.translation.width
                        card.y = value.translation.height
                        card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        labelIsVisible = !(card.x > 0 || card.x < 0)
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
                        labelIsVisible = !(card.x > 0 || card.x < 0)
                    }
                    if card.x < 0 {
                        viewModel.selectCardForDeletion(withID: card.id)
                    }
                }
        )
    }
}
