//
//  MissionsTabView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/24/25.
//

import GameKit
import MulticolorGradient
import SwiftUI

struct MissionsTabView: View {
    var namespace: Namespace.ID
    var mainDiver: Diver
    var divers: [Diver]

    @State private var selectedBadge: Badge?

    var body: some View {
        ZStack {
            GradientBackground(color: mainDiver.color.toColor)

            ScrollView {
                VStack {
                    TitleView(title: "Today's Missions")

                    MissionListView(
                        mainDiver: mainDiver,
                        divers: divers
                    )

                    TitleView(title: "Badges")

                    BadgeListView(
                        namespace: namespace,
                        mainDiver: mainDiver,
                        divers: divers
                    )
                }
                .compositingGroup()
                .shadow(color: .gray.opacity(0.2), radius: 8)
                .padding()
                .padding(.vertical, 80)
            }
            .scrollIndicators(.hidden)

            NavigationTitle(title: "MISSIONS", leading: {}, trailing: {})
        }
        .onAppear {
            GKAccessPoint.shared.isActive = true
        }
        .onDisappear {
            GKAccessPoint.shared.isActive = false
        }
    }

    private struct TitleView: View {
        let title: String

        var body: some View {
            Text(title)
                .font(.system(.title, design: .rounded))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassOpacity()
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    return NavigationStack {
        MissionsTabView(
            namespace: namespace,
            mainDiver: .builtin,
            divers: Diver.builtins + Diver.builtins + Diver.builtins
        )
    }
}
