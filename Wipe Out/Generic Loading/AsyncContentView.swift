//
//  AsyncContentView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 26.11.21.
//

import SwiftUI

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content
    
    init(source: Source,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
    }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform: source.load)
        case .loading:
            ProgressView()
        case .failed(let text):
            ErrorAlertView(retryHandler: source.load, title: text)
        case .loaded(let output):
            content(output)
        }
    }
}
