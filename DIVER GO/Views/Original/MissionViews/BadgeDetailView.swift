//
//  BadgeDetailView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/22/25.
//

import SwiftData
import SwiftUI

struct BadgeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]

    @Binding var mainDiver: Diver
    let badge: Badge
    let namespace: Namespace.ID

    @State private var angle: Double = 270

    var body: some View {
        VStack {
            ZStack {
                Image(.badge)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .grayscale(1)
                    .colorMultiply(badge.tintColor)
                    .brightness(0.1)
                if badge.category == .mbti {
                    Text(badge.infoDescription ?? "")
                        .font(.system(size: 64))
                        .bold()
                        .foregroundStyle(badge.tintColor)
                        .opacity(0.5)
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
            Text(badge.title)
                .font(.headline)
            Text(badge.description)
                .font(.footnote)
                .padding(.bottom)
            Text(
                "지금까지 \(badge.getBadgeCount(divers.filter { $0.id != mainDiver.id }))명 만났습니다."
            )
            .font(.caption)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5)) {
                angle = 0
            }
        }
    }

    private func normalizedDrag(value xOffset: Double, in width: CGFloat)
        -> Double
    {
        let half = Double(width / 2)
        let clamped = min(max(xOffset, -half), half)
        return clamped / half
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var mainDiver = Diver.builtin

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    container.mainContext.insert(mainDiver)

    for diver in Diver.builtins {
        container.mainContext.insert(diver)
    }

    return BadgeDetailView(
        mainDiver: $mainDiver,
        badge: Badge.badges[5],
        namespace: namespace
    )
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
