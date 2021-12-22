//
//  Card.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import UIKit
import Photos

class Card: ObservableObject, Identifiable {
    
    let id = UUID()
    let asset: PHAsset
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var degree: Double
    @Published var isSelected: Bool
    @Published var isEnabled: Bool

    init(asset: PHAsset,
         x: CGFloat = 0.0,
         y: CGFloat = 0.0,
         degree: CGFloat = 0.0,
         isSelected: Bool = false,
         isEnabled: Bool = false) {
        self.asset = asset
        self.x = x
        self.y = y
        self.degree = degree
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}
