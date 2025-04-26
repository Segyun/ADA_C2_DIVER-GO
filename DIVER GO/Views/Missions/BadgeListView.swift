//
//  BadgeListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct BadgeListView: View {
    var namespace: Namespace.ID
    var mainDiver: Diver
    var divers: [Diver]

    @State private var selectedBadge: Badge?

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(), count: 3)
        ) {
            ForEach(Badge.badges) { badge in
                BadgeCardView(
                    badge: badge,
                    isCompleted: badge.isCompleted(divers),
                    color: mainDiver.color.toColor
                )
                .matchedTransitionSource(id: badge.id, in: namespace)
                .onTapGesture {
                    selectedBadge = badge
                }
            }
        }
        .navigationDestination(item: $selectedBadge) { badge in
            BadgeDetailView(
                namespace: namespace,
                badge: badge,
                divers: divers
            )
            .toolbarVisibility(.hidden)
            .navigationTransition(.zoom(sourceID: badge.id, in: namespace))
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    NavigationStack {
        BadgeListView(
            namespace: namespace,
            mainDiver: .builtin,
            divers: Diver.builtins
        )
    }
}
