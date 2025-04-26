//
//  SecondaryButtonStyle.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

/// 투명도를 조절하는 버튼 스타일
/// - Parameters:
///   - color: 텍스트 색상
struct SecondaryButtonStyle: ButtonStyle {
    let color: Color

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? color : .secondary)
            .frame(maxWidth: .infinity)
            .glassOpacity()
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .glassShadow()
            .opacity(configuration.isPressed ? 0.3 : 1)
            .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

#Preview {
    let colors: [Color] = [.red, .green, .yellow, .blue]

    VStack {
        ForEach(colors, id: \.self) { color in
            Button("Secondary Button") {}
                .buttonStyle(SecondaryButtonStyle(color: color))
        }
    }
    .padding()
}
