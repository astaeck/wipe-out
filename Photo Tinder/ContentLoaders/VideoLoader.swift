//
//  VideoLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 26.11.21.
//

import AVKit
import Photos
import SwiftUI

class VideoLoader: LoadableObject {

    typealias Output = AVURLAsset
    @Published private(set) var state: LoadingState<AVURLAsset> = .idle
    private let imageManager: PHCachingImageManager
    private let asset: PHAsset
    
    init(asset: PHAsset, imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.asset = asset
        self.imageManager = imageManager
    }
    
    func load() {
        state = .loading

        let resultHandler: (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void = { video, _ , _ in
            guard let video = video as? AVURLAsset else { return }
            DispatchQueue.main.async {
                self.state = .loaded(video)
            }
        }
        
        imageManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: resultHandler)
    }
}
