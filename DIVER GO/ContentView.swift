//
//  ContentView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false

    init() {
        UITabBar.appearance().backgroundColor = .C_5.withAlphaComponent(0.1)
    }

    var body: some View {
        Group {
            if isOnboardingCompleted {
                TabView {
                    Tab("도감", systemImage: "book") {
                        DiverListView()
                    }
                    Tab("미션", systemImage: "list.bullet.clipboard") {
                        Text("미션")
                    }
                }
                .toolbarBackgroundVisibility(.hidden, for: .tabBar)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: DiverStore.shared.divers) {
            DiverStore.shared.saveData()
        }
        .onChange(of: DiverStore.shared.mainDiver) {
            DiverStore.shared.saveData()
        }
        .task {
            DiverStore.shared.loadData()
        }
    }
}

#Preview {
    ContentView()
}
