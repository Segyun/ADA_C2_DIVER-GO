//
//  GradientBackground.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import MulticolorGradient
import SwiftUI

/// 3가지 색상이 적용된 그라디언트 배경
/// - Parameters:
///   - color: 주요 배경 색상
struct GradientBackground: View {
    let color: Color

    var body: some View {
        MulticolorGradient {
            ColorStop(
                position: .topLeading,
                color: color.mix(with: .red, by: 0.7)
            )
            ColorStop(
                position: .trailing,
                color: color
            )
            ColorStop(
                position: .bottomLeading,
                color: color.mix(with: .blue, by: 0.7)
            )
        }
        .scaleEffect(1.1)
        .opacity(0.5)
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackground(color: .yellow)
}
