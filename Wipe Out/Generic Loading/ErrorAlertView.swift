//
//  ErrorAlertView.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 26.11.21.
//

import SwiftUI

struct ErrorAlertView: View {
    @State var retryHandler: (() -> Void)?
    @State var title: String
    @State private var presentAlert = true

    var body: some View {
        VStack {}
        .alert(title, isPresented: $presentAlert, actions: {
            Button("Retry") { retryHandler?() }
        })
    }
}
