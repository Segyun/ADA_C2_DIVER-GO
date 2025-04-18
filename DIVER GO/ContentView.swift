//
//  ContentView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftUI

enum OnboardingState: Int {
    case required
    case disappear
    case completed
}

struct ContentView: View {
    @ObservedObject private var diverStore = DiverStore.shared
    //    @State private var onboardingState: OnboardingState = .required

    init() {
        UITabBar.appearance().backgroundColor = .C_5.withAlphaComponent(0.1)
    }

    @AppStorage("onboardingState") var onboardingState: OnboardingState =
        .required

    var body: some View {
        Group {
            if onboardingState == .required {
                OnboardingView(onboardingState: $onboardingState)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .top)
                        )
                    )
            } else if onboardingState == .disappear {
                Color.C_4
                    .ignoresSafeArea()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .opacity
                        )
                    )
            } else if onboardingState == .completed {
                TabView {
                    Tab("도감", systemImage: "book") {
                        DiverListView()
                    }
                    Tab("미션", systemImage: "list.bullet.clipboard") {
                        MissionListView()
                    }
                }
                .toolbarBackgroundVisibility(.hidden, for: .tabBar)
                .transition(.opacity)
            }
        }
        .onChange(of: diverStore.divers) {
            diverStore.saveData()
        }
        .onChange(of: diverStore.mainDiver) {
            diverStore.saveData()
        }
        .task {
            diverStore.loadData()
        }
        .onOpenURL { url in
            let urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            let urlQueryItems = urlComponents?.queryItems ?? []

            diverStore.getSharedDiver(urlQueryItems)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
