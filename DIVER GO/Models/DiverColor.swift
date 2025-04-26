//
//  DiverColor.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

enum DiverColor: String, Codable, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case gray
    case brown
    case black
}

extension DiverColor {
    var toColor: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .black:
            return .black
        }
    }
}
