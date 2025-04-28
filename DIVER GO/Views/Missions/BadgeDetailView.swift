//
//  BadgeDetailView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import MulticolorGradient
import SwiftUI

struct BadgeDetailView: View {
    let namespace: Namespace.ID
    let badge: Badge
    let divers: [Diver]

    @Environment(\.dismiss) private var dismiss
    @State private var angle: Double = 270

    var body: some View {
        ZStack {
            BadgeDetailBackground

            VStack {
                if badge.isCompleted(divers) {
                    BadgeImageView
                } else {
                    IncompleteBadgeView
                }

                Text(badge.title)
                    .font(.headline)
                Text(badge.description)
                    .font(.footnote)
                    .padding(.bottom)
                Text(
                    "지금까지 \(badge.getBadgeCount(divers))명 만났습니다."
                )
                .font(.caption)
            }
            .glassOpacity()

            DismissButton()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
                .padding()
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                angle = 0
            }
        }
    }

    private var BadgeDetailBackground: some View {
        Group {
            MulticolorGradient {
                ColorStop(position: .top, color: .clear)
                ColorStop(position: .center, color: badge.tintColor)
                ColorStop(position: .bottom, color: .clear)
            }

            Rectangle()
                .fill(.regularMaterial)
        }
        .ignoresSafeArea()
    }

    private var BadgeImageView: some View {
        ZStack {
                Image(.badge)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .grayscale(1)
                    .colorMultiply(badge.tintColor)
                    .brightness(0.15)
                if badge.category == .mbti {
                    Text(badge.infoDescription ?? "")
                        .font(.system(size: 64, design: .rounded))
                        .bold()
                        .foregroundStyle(badge.tintColor)
                        .opacity(0.7)
                        .offset(y: 48)
                }
        }
        .frame(width: 250)
        .rotation3DEffect(
            .degrees(angle),
            axis: (x: 0, y: 1, z: 0)
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    angle = Double(value.translation.width)
                }
                .onEnded { _ in
                    withAnimation {
                        angle = 0
                    }
                }
        )
        .padding()
        .matchedGeometryEffect(id: badge.id, in: namespace)
    }
    
    private var IncompleteBadgeView: some View {
        Circle()
            .fill(.regularMaterial)
            .overlay {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1/3)
                    .glassOpacity()
            }
            .frame(width: 250)
            .padding()
    }

//    배지 이미지 추출
//    @State private var image: Image?
//
//    private var BadgeShareView: some View {
//        ShareLink(
//            item: image ?? Image(.badge),
//            preview: SharePreview(badge.title)
//        ) {
//            Image(systemName: "square.and.arrow.up")
//                .foregroundStyle(.white)
//                .padding(8)
//                .background(.regularMaterial, in: Circle())
//                .padding()
//        }
//        .onAppear {
//            let renderer = ImageRenderer(
//                content: ZStack {
//                    Image(.badge)
//                        .resizable()
//                        .interpolation(.high)
//                        .scaledToFit()
//                        .grayscale(1)
//                        .colorMultiply(badge.tintColor)
//                        .brightness(0.15)
//                    if badge.category == .mbti {
//                        Text(badge.infoDescription ?? "")
//                            .font(.system(size: 64, design: .rounded))
//                            .bold()
//                            .foregroundStyle(badge.tintColor)
//                            .opacity(0.7)
//                            .offset(y: 48)
//                    }
//                }
//                .frame(width: 250)
//            )
//
//            renderer.scale = 4
//
//            if let renderedImage = renderer.uiImage {
//                image = Image(uiImage: renderedImage)
//            }
//        }
//    }
}

#Preview {
    @Previewable @Namespace var namespace

    BadgeDetailView(
        namespace: namespace,
        badge: .badges.first!,
        divers: Diver.builtins
    )
}
