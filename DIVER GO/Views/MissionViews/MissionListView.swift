//
//  MissionListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import GameKit
import SwiftData
import SwiftUI

struct MissionListView: View {
    @Binding var mainDiver: Diver

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]
    @Namespace private var namespace

    @AppStorage("lastMissionDate") private var lastMissionDate: Date?
    @AppStorage("lastMissionDiverID") private var lastMissionDiverID: String?

    // ScrollViewReader에서 사용할 ID
    private let missionHeaderId = "mission"
    private let badgeHeaderId = "badge"

    @State private var selectedBadge: Badge?

    fileprivate func updateRandomDiverMeet() {
        if let lastMissionDate {
            let dateComponents = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: lastMissionDate
            )

            if dateComponents
                == Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: Date()
                )
            {
                return
            }
        }

        if divers.count > 0 {
            lastMissionDate = Date()
            lastMissionDiverID =
                divers.filter { $0.id != mainDiver.id }.stableRandom()?.id
                    .uuidString
        }
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
                    Color.C_4
                        .ignoresSafeArea()

                    ScrollView {
                        LazyVStack(
                            alignment: .leading,
                            pinnedViews: [.sectionHeaders]
                        ) {
                            Section {
                                MissionRowView(
                                    mainDiver: $mainDiver,
                                    mission: .builtin
                                )
                                if let mbtiMission = Mission.mbtiMission
                                    .stableRandom()
                                {
                                    MissionRowView(
                                        mainDiver: $mainDiver,
                                        mission: mbtiMission
                                    )
                                }
                                if let randomDiver = divers.first(
                                    where: {
                                        $0.id.uuidString == lastMissionDiverID
                                    })
                                {
                                    MissionRowView(
                                        mainDiver: $mainDiver,
                                        mission: .diverMission(randomDiver)
                                    )
                                }
                            } header: {
                                MissionHeaderView()
                                    .id(missionHeaderId)
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(
                                                missionHeaderId,
                                                anchor: .top
                                            )
                                        }
                                    }
                            }

                            Section {
                                LazyVGrid(
                                    columns: Array(
                                        repeating: GridItem(),
                                        count: 3
                                    )
                                ) {
                                    ForEach(Badge.badges) { badge in
                                        BadgeItemView(
                                            mainDiver: $mainDiver,
                                            selectedBadge: $selectedBadge,
                                            badge: badge,
                                            namespace: namespace
                                        )
                                        .onTapGesture {
                                            selectedBadge = badge
                                        }
                                    }
                                }
                            } header: {
                                BadgeHeaderView()
                                    .id(badgeHeaderId)
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(
                                                badgeHeaderId,
                                                anchor: .top
                                            )
                                        }
                                    }
                            }
                        }
                        .listSectionSpacing(0)
                        .padding([.leading, .trailing, .bottom])
                    }
                    .clipped()
                }
            }
            .navigationDestination(item: $selectedBadge) { badge in
                ZStack {
                    Group {
                        Color.C_5

                        RadialGradient(
                            gradient: Gradient(colors: [
                                badge.tintColor, .clear,
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 300
                        )
                        .opacity(0.3)
                    }
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedBadge = nil
                    }

                    BadgeDetailView(badge: badge, namespace: namespace)
                }
                .toolbar(.hidden)
                .navigationTransition(.zoom(sourceID: badge.id, in: namespace))
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            GKAccessPoint.shared.isActive = true

            updateRandomDiverMeet()
        }
        .onDisappear {
            GKAccessPoint.shared.isActive = false
        }
    }
}

// MARK: - Subviews

// 미션 리스트의 미션 행을 나타내는 뷰
struct MissionRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]

    @Binding var mainDiver: Diver
    let mission: Mission

    var body: some View {
        VStack {
            HStack {
                Text(mission.description)
                    .font(.headline)
                Spacer()
            }
            HStack {
                ProgressView(
                    value: Double(
                        mission.getMissionCount(
                            divers.filter { $0.id != mainDiver.id }
                        )
                    )
                        / Double(
                            mission.count
                        )
                )
                .progressViewStyle(.linear)
                Text(
                    "\(mission.getMissionCount(divers.filter { $0.id != mainDiver.id }))/\(mission.count)"
                )
            }
        }
        .padding(.vertical)
    }
}

// 미션 리스트의 미션 헤더를 나타내는 뷰
struct MissionHeaderView: View {
    var body: some View {
        HStack {
            Text("오늘의 미션")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background {
            Color.C_4
        }
    }
}

// 미션 리스트의 배지 행을 나타내는 뷰
struct BadgeItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]

    @Binding var mainDiver: Diver
    @Binding var selectedBadge: Badge?
    let badge: Badge

    var namespace: Namespace.ID

    var body: some View {
        VStack {
            Circle()
                .stroke(
                    badge.strokeColor(divers.filter { $0.id != mainDiver.id }),
                    lineWidth: 10
                )
                .overlay {
                    Group {
                        Image(.badge)
                            .resizable()
                            .interpolation(.high)
                            .scaledToFit()
                            .grayscale(1)
                            .colorMultiply(badge.tintColor)
                            .brightness(0.1)
                        if badge.category == .mbti, let mbti = badge.infoDescription {
                            Text(mbti)
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(badge.tintColor)
                                .opacity(0.5)
                                .offset(y: 18)
                        }
                    }
                    .matchedTransitionSource(id: badge.id, in: namespace)
                }
                .padding(.bottom, 8)
            Text(badge.title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(badge.description)
                .font(.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .onAppear {
            if badge.isCompleted(divers.filter { $0.id != mainDiver.id }) {
                Task {
                    let achievement = GKAchievement(identifier: badge.id)
                    achievement.percentComplete = 100

                    do {
                        try await GKAchievement.report([achievement])
                    } catch {
                        print("Failed to report achievement: \(error)")
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation {
                selectedBadge = badge
            }
        }
    }
}

// 미션 리스트의 배지 헤더를 나타내는 뷰
struct BadgeHeaderView: View {
    var body: some View {
        HStack {
            Text("배지")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background {
            Color.C_4
        }
    }
}

#Preview {
    @Previewable @State var mainDiver = Diver("Main Diver", isDefaultInfo: true)

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Diver.self, configurations: config)

    container.mainContext.insert(mainDiver)

    for i in 1 ..< 10 {
        let diver = Diver("Test \(i)", isDefaultInfo: true)
        container.mainContext.insert(diver)
    }

    return MissionListView(mainDiver: $mainDiver)
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
