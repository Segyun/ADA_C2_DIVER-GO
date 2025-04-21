//
//  MissionListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import SwiftData
import SwiftUI

struct MissionListView: View {
    @Binding var mainDiver: Diver
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Diver.updatedAt) private var divers: [Diver]

    // ScrollViewReader에서 사용할 ID
    private let missionHeaderId = "mission"
    private let badgeHeaderId = "badge"

    var body: some View {
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
                            if let mbtiMission = Mission.mbtiMission.stableRandom()
                            {
                                MissionRowView(
                                    mainDiver: $mainDiver,
                                    mission: mbtiMission
                                )
                            }
                            if let randomDiver = divers.filter({ $0.id != mainDiver.id }).stableRandom() {
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
                                        badge: badge
                                    )
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
                    .padding()
                }
                .clipped()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

// 미션 리스트의 미션 행을 나타내는 뷰
struct MissionRowView: View {    @Environment(\.modelContext) private var modelContext
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
                    value: Double(mission.getMissionCount(divers.filter({ $0.id != mainDiver.id })))
                        / Double(
                            mission.count
                        )
                )
                .progressViewStyle(.linear)
                Text("\(mission.getMissionCount(divers))/\(mission.count)")
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
        .padding(.bottom)
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
    let badge: Badge
    
    var body: some View {
        VStack {
            Circle()
                .stroke(badge.strokeColor(divers.filter({ $0.id != mainDiver.id })), lineWidth: 10)
                .overlay {
                    Image(.badge)
                        .resizable()
                        .scaledToFit()
                        .grayscale(1)
                        .colorMultiply(badge.tintColor)
                        .brightness(0.1)
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
        .padding(.bottom)
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
    
    for i in 1..<10 {
        let diver = Diver("Test \(i)", isDefaultInfo: true)
        container.mainContext.insert(diver)
    }

    return MissionListView(mainDiver: $mainDiver)
        .preferredColorScheme(.dark)
        .modelContainer(container)
}
