//
//  CustomButtonStyle.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 30.11.21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .frame(width: 80, height: 45)
      .foregroundColor(.white)
      .background(Color.blue)
      .opacity(configuration.isPressed ? 0.8 : 1.0)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
