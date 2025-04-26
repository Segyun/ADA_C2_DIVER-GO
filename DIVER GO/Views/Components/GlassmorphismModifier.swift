//
//  GlassmorphismModifier.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct GlassShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.1), radius: 8)
    }
}

extension View {
    func glassShadow() -> some View {
        modifier(GlassShadow())
    }
}

struct GlassOpacity: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.7)
    }
}

extension View {
    func glassOpacity() -> some View {
        modifier(GlassOpacity())
    }
}
