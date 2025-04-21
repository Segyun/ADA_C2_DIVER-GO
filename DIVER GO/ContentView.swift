//
//  ContentView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftData
import SwiftUI
import UserNotifications

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
                        MissionListView(mainDiver: $mainDiver)
                    }
                }
                .toolbarBackgroundVisibility(.hidden, for: .tabBar)
                .transition(.opacity)
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
                            existingDiver.infoList = diver.infoList
                            existingDiver.updatedAt = Date()

                            diver = existingDiver
                        } else {
                            diver.createdAt = Date()
                            diver.updatedAt = Date()

                            context.insert(diver)
                        }

                        #if DEBUG
                            print("Shared diver: \(diver.description)")
                        #endif

                        selectedDiver = diver

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

                        #if DEBUG
                            UNUserNotificationCenter.current()
                                .getPendingNotificationRequests { requests in
                                    for request in requests {
                                        print(request.content.body)
                                    }
                                }
                        #endif
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    for i in 1 ..< 10 {
        let diver = Diver("Test \(i)", isDefaultInfo: true)
        container.mainContext.insert(diver)
    }

    return ContentView()
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
