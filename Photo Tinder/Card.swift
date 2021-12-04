//
//  Card.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 24.11.21.
//

import UIKit
import Photos

struct Card: Identifiable, Hashable {
    let id = UUID()
    let asset: PHAsset
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
}
