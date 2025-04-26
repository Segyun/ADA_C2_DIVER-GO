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

enum OnboardingState: Int {
    case required
    case completed
}

struct MainView: View {
    @AppStorage("onboardingState") var onboardingState: OnboardingState =
        .required
    @AppStorage("mainDiverID") var mainDiverID: String?

    @Environment(\.modelContext) private var context
    @Query(sort: \Diver.nickname) private var divers: [Diver]
    @Namespace private var namespace

    @State private var mainDiver = Diver()
    @State private var selectedDiver: Diver?
    @State private var tabState: TabState = .book
    @State private var appearAnimating = false

    var body: some View {
        NavigationStack {
            ZStack {
                switch onboardingState {
                case .required:
                    OnboardingView(
                        onboardingState: $onboardingState,
                        mainDiver: $mainDiver
                    )
                case .completed:
                    Group {
                        switch tabState {
                        case .book:
                            DiverBookTabView(
                                namespace: namespace,
                                mainDiver: $mainDiver,
                                selectedDiver: $selectedDiver
                            )
                            .transition(.opacity)
                        case .mission:
                            MissionsTabView(
                                namespace: namespace,
                                mainDiver: mainDiver,
                                divers: divers.filter { $0.id != mainDiver.id }
                            )
                            .transition(.opacity)
                        }

                        TabBar
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
            requestUserNotificationPermission()

            if let mainDiverID, let diver = divers.first(
                where: {
                    $0.id.uuidString == mainDiverID
                })
            {
                mainDiver = diver
            } else {
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
                for item in urlQueryItems {
                    if item.name == "id", let id = item.value {
                        openDiver(id)
                    }
                }
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

                        updateDiver(&diver)
                    }
                }
            }
        }
    }

    private enum TabState {
        case book
        case mission
    }

    private var TabBar: some View {
        HStack {
            BookTabItem
            MissionsTabItem
        }
        .font(.callout)
        .padding(8)
        .background(.regularMaterial, in: Capsule())
        .padding(.top, 40)
        .frame(
            maxWidth: .infinity)
        .background {
            FadingBackground()
        }
        .frame(
            maxHeight: .infinity,
            alignment: .bottom
        )
    }

    private var BookTabItem: some View {
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
    }

    private var MissionsTabItem: some View {
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

    /// 게임 센터 사용자 인증을 요청합니다.
    private func authenticateGameCenterUser() {
        GKLocalPlayer.local.authenticateHandler = { _, error in
            guard error == nil else {
                return
            }
        }
    }

    /// 사용자에게 알림 권한을 요청합니다.
    private func requestUserNotificationPermission() {
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
    }

    /// 다이버 알림을 추가합니다.
    /// - Parameter diver: 알림을 추가할 다이버
    private func addDiverNotification(_ diver: Diver) {
        let content = UNMutableNotificationContent()
        content.title = "DIVER GO"
        content.body =
            "\(diver.emoji) \(diver.nickname)을 5일 전에 마지막으로 만났어요."
        content.sound = UNNotificationSound.default

        guard
            let triggerDate = Calendar.current.date(
                byAdding: .second,
                value: 5,
                to: Date()
            )
        else {
            return
        }

        var triggerDateComponents = Calendar.current
            .dateComponents(
                [.year, .month, .day],
                from: triggerDate
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

    /// 다이버 상세 화면으로 이동합니다.
    /// - Parameter id: 다이버 ID
    private func openDiver(_ id: String) {
        let diver = divers.first(where: { $0.id.uuidString == id })

        selectedDiver = diver
    }

    /// 다이버를 업데이트합니다.
    /// - Parameter diver: 업데이트할 다이버
    private func updateDiver(_ diver: inout Diver) {
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    for diver in Diver.builtins {
        container.mainContext.insert(diver)
    }

    return MainView()
        .modelContainer(container)
}
