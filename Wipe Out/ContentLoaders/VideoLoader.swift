//
//  VideoLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 26.11.21.
//

import AVKit
import Photos
import SwiftUI

class VideoLoader: LoadableObject {

    typealias Output = AVPlayer
    @Published private(set) var state: LoadingState<AVPlayer> = .idle
    private let imageManager: PHCachingImageManager
    private let asset: PHAsset
    private var videoPlayer: AVPlayer?
    
    init(asset: PHAsset, imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.asset = asset
        self.imageManager = imageManager
    }
    
    func load() {
        state = .loading

        let resultHandler: (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void = { video, _ , _ in
            guard let video = video as? AVURLAsset else { return }
            DispatchQueue.main.async {
                self.videoPlayer = AVPlayer(url: video.url)
                guard let videoPlayer = self.videoPlayer else {
                    self.state = .failed("video not available")
                    return
                }
                self.state = .loaded(videoPlayer)
            }
        }
        
        imageManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: resultHandler)
    }
    
    func pause() {
        videoPlayer?.pause()
    }
}
