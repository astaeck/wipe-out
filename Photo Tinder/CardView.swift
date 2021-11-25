//
//  CardView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import SwiftUI
import Combine
import Photos

struct CardView: View {
    @State var card: Card
    @ObservedObject var imageLoader: ImageLoader
    @State var image = UIImage()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Image(uiImage: image)
                .resizable()
                .clipped()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .padding()
                .foregroundColor(.white)
                .onReceive(imageLoader.didChange) { image in
                    self.image = image
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

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }

    init(asset: PHAsset) {
        fetchImageAsset(asset, targetSize: CGSize(width: 300, height: 300), completionHandler: nil)
    }
    
    func fetchImageAsset(_ asset: PHAsset?, targetSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, options: PHImageRequestOptions? = nil, completionHandler: ((Bool) -> Void)?) {
        guard let asset = asset else {
            completionHandler?(true)
            return
        }
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
            guard let image = image else {
                completionHandler?(true)
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            completionHandler?(true)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
               targetSize: size,
               contentMode: contentMode,
               options: options,
               resultHandler: resultHandler)
    }
}

