//
//  CustomButtonStyle.swift
//  Photo Tinder
//
//  Created by Angelina Staeck on 30.11.21.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundColor(.white)
      .padding(10)
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
