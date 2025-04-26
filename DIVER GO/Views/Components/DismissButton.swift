//
//  DismissButton.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .padding(8)
                .background(Circle().fill(.ultraThickMaterial))
                .glassShadow()
        }
    }
}
