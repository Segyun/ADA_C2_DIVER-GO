//
//  PrimaryButtonStyle.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

/// 색상과 투명도를 조절하는 버튼 스타일
/// - Parameters:
///   - color: 버튼의 배경 색상
struct PrimaryButtonStyle: ButtonStyle {
    let color: Color

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? color.adaptedTextColor() : .secondary)
            .frame(maxWidth: .infinity)
            .glassOpacity()
            .padding()
            .background {
                if isEnabled {
                    color
                        .glassOpacity()
                } else {
                    Rectangle()
                        .fill(.regularMaterial)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .glassShadow()
            .opacity(configuration.isPressed ? 0.3 : 1)
            .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

#Preview {
    let colors: [Color] = [.red, .green, .yellow, .blue]

    VStack {
        ForEach(colors, id: \.self) { color in
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle(color: color))
        }
    }
    .padding()
}
