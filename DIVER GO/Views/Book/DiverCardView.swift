//
//  DiverCardView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct DiverCardView: View {
    let diver: Diver

    var body: some View {
        VStack {
            Circle()
                .fill(.regularMaterial)
                .frame(width: 72)
                .overlay {
                    if diver.emoji.isEmpty {
                        Image(.diver)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        Text(diver.emoji)
                            .font(.system(size: 32))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }

            VStack(alignment: .center) {
                Text(diver.nickname)
                    .font(.system(.headline, design: .rounded))
                    .opacity(0.7)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if let session = diver.infoList.first(where: {
                    $0.title == "세션"
                }
                ) {
                    Text(
                        session.description.isEmpty ? "세션" : session.description
                    )
                    .font(.caption)
                    .opacity(0.6)
                    .padding(8)
                    .background(
                        .thickMaterial,
                        in: RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            VStack(spacing: 0) {
                diver.color.toColor.opacity(0.3)
                Color(.systemBackground).opacity(0.8)
            }
            Rectangle()
                .fill(.thinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    DiverCardView(diver: .builtin)
}
