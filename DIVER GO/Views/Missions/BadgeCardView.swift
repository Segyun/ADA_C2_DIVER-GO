//
//  BadgeCardView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct BadgeCardView: View {
    let badge: Badge
    let isCompleted: Bool
    let color: Color

    var body: some View {
        VStack {
            ZStack {
                if isCompleted {
                    Image(.badge)
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .grayscale(1)
                        .colorMultiply(badge.tintColor)
                        .padding(.bottom)
                    
                    if badge.category == .mbti,
                       let mbti = badge.infoDescription
                    {
                        Text(mbti)
                            .font(.system(size: 20, design: .rounded))
                            .bold()
                            .foregroundStyle(badge.tintColor)
                            .opacity(0.5)
                            .offset(y: 12)
                    }
                } else {
                    Circle()
                        .fill(.regularMaterial)
                        .overlay {
                            Image(systemName: "lock.fill")
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(1/3)
                                .glassOpacity()
                        }
                        .padding(.bottom)
                }
            }
            .brightness(0.15)

            VStack(alignment: .center) {
                Text(badge.title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(isCompleted ? color : Color(.label))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(badge.description)
                    .font(.system(.caption, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .glassOpacity()
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            VStack(spacing: 0) {
                badge.tintColor.opacity(0.3)
                Color(.systemBackground).opacity(0.8)
            }
            Rectangle()
                .fill(.thinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    BadgeCardView(badge: .badges.first!, isCompleted: false, color: .red)
}
