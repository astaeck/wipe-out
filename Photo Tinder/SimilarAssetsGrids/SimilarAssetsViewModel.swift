//
//  SimilarAssetsViewModel.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 01.02.22.
//

import Foundation

class SimilarAssetsViewModel: LoadableObject {
    typealias Output = [Card]
    
    @Published private(set) var state: LoadingState<[Card]> = .idle

    func load() {
        
    }
}
