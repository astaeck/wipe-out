//
//  VideoLoader.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 26.11.21.
//

import Combine
import AVKit
import Photos
import SwiftUI

class VideoLoader: ObservableObject {
    var didChange = PassthroughSubject<AVURLAsset, Never>()
    private let imageManager: PHCachingImageManager
    private let asset: PHAsset
    private var video: AVURLAsset? {
        didSet {
            guard let video = video else { return }
            didChange.send(video)
        }
    }
    
    init(asset: PHAsset, imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.asset = asset
        self.imageManager = imageManager
        
        fetchVideoAsset()
    }
    
    
    func fetchVideoAsset() {
        
        let resultHandler: (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void = { video, audioMix, info in
            guard let video = video as? AVURLAsset else { return }
            DispatchQueue.main.async {
                self.video = video
            }
        }
        
        imageManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: resultHandler)
    }
}
