//
//  ProfileImageView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftUI

struct ProfileImageView: View {
    var emoji: String = ""
    var strokeColor: Color = .C_1

    var body: some View {
        Circle()
            .fill(.thinMaterial)
            .stroke(strokeColor, lineWidth: 5)
            .overlay {
                if emoji.isEmpty {
                    Color.white
                        .opacity(0.2)
                        .mask {
                            Image(.diver)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.6)
                        }
                } else {
                    Text(emoji)
                        .font(.system(size: 256))
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(0.6)
                }
            }
    }
}

#Preview {
    ProfileImageView()
        .preferredColorScheme(.dark)
}
