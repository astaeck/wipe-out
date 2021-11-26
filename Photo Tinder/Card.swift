//
//  Card.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import UIKit
import Photos

struct Card: Identifiable {
    let id = UUID()
    let index: Int
    let asset: PHAsset
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
}
