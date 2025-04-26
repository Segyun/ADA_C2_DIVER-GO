//
//  FadingBackground.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

/// Material 스타일이 적용된 배경
/// - Parameters:
///   - gradientDirection: 배경의 그라디언트 방향
///   - material: Material 스타일
struct FadingBackground: View {
    var gradientDirection: GradientDirection = .topToBottom
    var material: Material = .ultraThinMaterial

    var body: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: gradientDirection.topLeadingRadius,
            bottomLeadingRadius: gradientDirection.bottomLeadingRadius,
            bottomTrailingRadius: gradientDirection.bottomTrailingRadius,
            topTrailingRadius: gradientDirection.topTrailingRadius
        )
        .fill(material)
        .mask {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.3),
                    .init(color: .black, location: 1),
                ],
                startPoint: gradientDirection.startPoint,
                endPoint: gradientDirection.endPoint
            )
        }
        .ignoresSafeArea()
    }
    
    enum GradientDirection {
        case topToBottom
        case bottomToTop

        var topLeadingRadius: CGFloat {
            switch self {
            case .topToBottom:
                return 0
            case .bottomToTop:
                return 30
            }
        }

        var topTrailingRadius: CGFloat {
            switch self {
            case .topToBottom:
                return 0
            case .bottomToTop:
                return 30
            }
        }

        var bottomLeadingRadius: CGFloat {
            switch self {
            case .topToBottom:
                return 30
            case .bottomToTop:
                return 0
            }
        }

        var bottomTrailingRadius: CGFloat {
            switch self {
            case .topToBottom:
                return 30
            case .bottomToTop:
                return 0
            }
        }

        var startPoint: UnitPoint {
            switch self {
            case .topToBottom:
                return .top
            case .bottomToTop:
                return .bottom
            }
        }

        var endPoint: UnitPoint {
            switch self {
            case .topToBottom:
                return .bottom
            case .bottomToTop:
                return .top
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.red, .green],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        Button("Top") {}
            .buttonStyle(PrimaryButtonStyle(color: .blue))
            .padding()
            .padding(.bottom, 32)
            .background {
                FadingBackground(gradientDirection: .bottomToTop)
            }
            .frame(maxHeight: .infinity, alignment: .top)

        Button("Bottom") {}
            .buttonStyle(PrimaryButtonStyle(color: .blue))
            .padding()
            .padding(.top, 32)
            .background {
                FadingBackground()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
}
