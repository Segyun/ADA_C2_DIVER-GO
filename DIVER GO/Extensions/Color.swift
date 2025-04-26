//
//  Color.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

extension Color {
    /// 색상의 밝기를 계산합니다.
    /// - Returns: 색상의 밝기 (0.0 ~ 1.0)
    func luminance() -> Double {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }

    /// 색상의 밝기에 따른 텍스트 색상을 결정합니다.
    /// - Returns: 텍스트 색상
    func adaptedTextColor() -> Color {
        luminance() > 0.5 ? .black : .white
    }
}
