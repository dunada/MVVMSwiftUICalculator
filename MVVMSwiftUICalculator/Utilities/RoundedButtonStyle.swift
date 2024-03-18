//
//  ButtonStyle.swift
//  MVVMSwiftUICalculator
//
//  Created by Eduardo Rodrigues on 08/03/24.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {

    var size: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var isBig: Bool = false


    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 32, weight: .medium))
            .frame(maxWidth: isBig ? size * 2 + 12 : size, maxHeight: size, alignment: .center)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .overlay {
                if configuration.isPressed {
                    Color(white: 1.0, opacity: 0.3)
                }
            }
            .clipShape(Capsule())

    }
}
