//
//  MainView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/24/25.
//

import GameKit
import SwiftData
import SwiftUI
import UserNotifications

struct MainView: View {
    @AppStorage("onboardingState") var onboardingState: OnboardingState =
        //    @State var onboardingState: OnboardingState =
        .required
    @AppStorage("mainDiverID") var mainDiverID: String?

    @Environment(\.modelContext) private var context
    @Query(sort: \Diver.nickname) private var divers: [Diver]
    @Namespace private var namespace

    @State private var mainDiver = Diver()
    @State private var selectedDiver: Diver?
    @State private var tabState: TabState = .book
    @State private var appearAnimating = false

    enum TabState {
        case book
        case mission
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if onboardingState == .required {
                    Onboarding(
                        onboardingState: $onboardingState,
                        mainDiver: $mainDiver
                    )
                } else {
                    Group {
                        if tabState == .book {
                            DiverList(
                                namespace: namespace,
                                mainDiver: $mainDiver,
                                selectedDiver: $selectedDiver
                            )
                            .transition(.opacity)
                        } else if tabState == .mission {
                            MissionList(
                                namespace: namespace,
                                mainDiver: mainDiver,
                                divers: divers.filter { $0.id != mainDiver.id }
                            )
                            .transition(.opacity)
                        }
                        
                        HStack {
                            Label("도감", systemImage: "book.pages")
                                .padding(8)
                                .padding(.horizontal, 8)
                                .background {
                                    if tabState == .book {
                                        Capsule()
                                            .fill(
                                                mainDiver.color.toColor
                                            )
                                            .matchedGeometryEffect(
                                                id: "button",
                                                in: namespace
                                            )
                                        
                                    }
                                }
                                .foregroundStyle(
                                    tabState == .book ? .white : .secondary
                                )
                                .onTapGesture {
                                    withAnimation {
                                        tabState = .book
                                    }
                                }
                            Label("미션", systemImage: "list.bullet.clipboard")
                                .padding(8)
                                .padding(.horizontal, 8)
                                .background {
                                    if tabState == .mission {
                                        Capsule()
                                            .fill(
                                                mainDiver.color.toColor
                                            )
                                            .matchedGeometryEffect(
                                                id: "button",
                                                in: namespace
                                            )
                                        
                                    }
                                }
                                .foregroundStyle(
                                    tabState == .mission ? .white : .secondary
                                )
                                .onTapGesture {
                                    withAnimation {
                                        tabState = .mission
                                    }
                                }
                        }
                        .font(.callout)
                        .padding(8)
                        .background(.regularMaterial, in: Capsule())
                        .padding(.bottom, 20)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottom
                        )
                    }
                    .opacity(appearAnimating ? 1 : 0)
                    .onAppear {
                        withAnimation {
                            appearAnimating = true
                        }
                    }
                }
            }
        }
        .onAppear {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) {
                sucess,
                error in
                if sucess {
                    print("Notification permission granted.")
                } else if let error {
                    print(error)
                }
            }

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
                onboardingState = .required
            }
        }
        .onOpenURL { url in
            let urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            let urlQueryItems = urlComponents?.queryItems ?? []

            tabState = .book
            
            if urlComponents?.host == "open" {
                guard
                    let idString = urlQueryItems.first(where: {
                        $0.name == "id"
                    })?.value
                else {
                    return
                }

                let diver = divers.first(where: { $0.id.uuidString == idString }
                )

                selectedDiver = diver
            } else if urlComponents?.host == "share" {
                for item in urlQueryItems {
                    updateDiver(item)
                }
            }
        }
    }

    private func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }

    private func addDiverNotification(_ diver: Diver) {
        let content = UNMutableNotificationContent()
        content.title = "DIVER GO"
        content.body =
            "\(diver.emoji) \(diver.nickname)을 5일 전에 마지막으로 만났어요."
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.date(
            byAdding: .second,
            value: 5,
            to: Date()
        )

        var triggerDateComponents = Calendar.current
            .dateComponents(
                [.year, .month, .day],
                from: triggerDate!
            )

        triggerDateComponents.hour = 9
        triggerDateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDateComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: diver.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func updateDiver(_ item: URLQueryItem) {
        if item.name == "diver" {
            guard
                let diverData = Data(
                    base64Encoded: item.value ?? ""
                )
            else {
                return
            }

            guard
                var diver = try? JSONDecoder().decode(
                    Diver.self,
                    from: diverData
                )
            else {
                return
            }

            if let existingDiver = divers.first(
                where: { $0.id == diver.id }
            ) {
                existingDiver.nickname = diver.nickname
                existingDiver.emoji = diver.emoji
                existingDiver.color = diver.color
                existingDiver.infoList = diver.infoList
                existingDiver.updatedAt = Date()

                diver = existingDiver
            } else {
                diver.createdAt = Date()
                diver.updatedAt = Date()

                context.insert(diver)
            }

            selectedDiver = diver

            addDiverNotification(diver)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    for diver in Diver.builtins {
        container.mainContext.insert(diver)
    }

    return MainView()
        .modelContainer(container)
}
