//
//  Card.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 24.11.21.
//

import UIKit
import Photos

class Card: ObservableObject, Identifiable, Equatable {
    
    let id = UUID()
    let asset: PHAsset
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var degree: Double
    @Published var isSelected: Bool
    @Published var isPreSelected: Bool
    @Published var isEnabled: Bool

    init(asset: PHAsset,
         x: CGFloat = 0.0,
         y: CGFloat = 0.0,
         degree: CGFloat = 0.0,
         isSelected: Bool = false,
         isPreSelected: Bool = false,
         isEnabled: Bool = false) {
        self.asset = asset
        self.x = x
        self.y = y
        self.degree = degree
        self.isSelected = isSelected
        self.isPreSelected = isPreSelected
        self.isEnabled = isEnabled
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
