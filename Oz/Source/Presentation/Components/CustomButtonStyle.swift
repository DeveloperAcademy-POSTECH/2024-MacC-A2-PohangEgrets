//
//  CustomButtonStyle.swift
//  AsyncC
//
//  Created by Jin Lee on 11/18/24.
//

import SwiftUI

struct CustomButtonStyle: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .cornerRadius(5)
    }
}

extension View {
    func customButtonStyle(backgroundColor: Color, foregroundColor: Color) -> some View {
        self.modifier(CustomButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}
