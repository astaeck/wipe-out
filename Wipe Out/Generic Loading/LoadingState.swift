//
//  LoadingState.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 26.11.21.
//

import SwiftUI

enum LoadingState<Value> {
    case idle
    case loading
    case failed(String)
    case loaded(Value)
}
