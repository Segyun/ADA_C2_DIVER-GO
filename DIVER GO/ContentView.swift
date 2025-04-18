//
//  ContentView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftData
import SwiftUI

enum OnboardingState: Int {
    case required
    case disappear
    case completed
}

struct ContentView: View {
    @AppStorage("onboardingState") var onboardingState: OnboardingState =
        .required
    @AppStorage("mainDiverID") var mainDiverID: String?

    @Environment(\.modelContext) private var context
    @Query private var divers: [Diver]

    @State private var mainDiver = Diver("", isDefaultInfo: true)

    @State private var selectedDiver: Diver?

    var body: some View {
        Group {
            if onboardingState == .required {
                OnboardingView(
                    mainDiver: $mainDiver,
                    onboardingState: $onboardingState
                )
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
                        DiverListView(
                            mainDiver: $mainDiver,
                            selectedDiver: $selectedDiver
                        )
                    }
                    Tab("미션", systemImage: "list.bullet.clipboard") {
                        MissionListView()
                    }
                }
                .toolbarBackgroundVisibility(.hidden, for: .tabBar)
                .transition(.opacity)
            }
        }
        .onAppear {
            if let mainDiverID {
                #if DEBUG
                    print("mainDiverID exists: \(mainDiverID)")
                #endif
                guard
                    let diver = divers.first(
                        where: {
                            $0.id.uuidString == mainDiverID
                        })
                else { return }
                mainDiver = diver
            } else {
                #if DEBUG
                    print("mainDiverID not exists")
                #endif
                mainDiverID = mainDiver.id.uuidString
                context.insert(mainDiver)
            }
        }
        .onOpenURL { url in
            let urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            let urlQueryItems = urlComponents?.queryItems ?? []

            var diver = Diver("", isDefaultInfo: false)

            for item in urlQueryItems {
                switch item.name {
                case Diver.CodingKeys.id.stringValue:
                    diver.id = UUID(uuidString: item.value!)!
                    if let index = divers.firstIndex(where: { $0.id == diver.id}) {
                        diver = divers[index]
                        diver.infoList.removeAll()
                    } else {
                        context.insert(diver)
                    }
                case Diver.CodingKeys.nickname.stringValue:
                    diver.nickname = item.value ?? ""
                case Diver.CodingKeys.emoji.stringValue:
                    diver.emoji = item.value ?? ""
                case Diver.CodingKeys.createdAt.stringValue:
                    diver.createdAt = item.value?.toDate() ?? Date()
                case Diver.CodingKeys.updatedAt.stringValue:
                    diver.updatedAt = item.value?.toDate() ?? Date()
                default:
                    diver.infoList
                        .append(
                            DiverInfo(
                                title: item.name,
                                description: item.value ?? ""
                            )
                        )
                }
            }
            
            selectedDiver = diver
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    for i in 1..<10 {
        let diver = Diver("Test \(i)", isDefaultInfo: true)
        container.mainContext.insert(diver)
    }

    return ContentView()
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
