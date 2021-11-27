//
//  LoadableObject.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 26.11.21.
//

import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}
