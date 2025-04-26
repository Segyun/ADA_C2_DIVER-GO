//
//  MissionListView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct MissionListView: View {
    var mainDiver: Diver
    var divers: [Diver]

    @AppStorage("lastMissionDate") private var lastMissionDate: Date?
    @AppStorage("lastMissionDiverID") private var lastMissionDiverID: String?

    var body: some View {
        VStack {
            MissionCardView(
                divers: divers,
                mission: .builtin,
                tintColor: mainDiver.color.toColor
            )
            if let mbtiMission = Mission.mbtiMission
                .stableRandom()
            {
                MissionCardView(
                    divers: divers,
                    mission: mbtiMission,
                    tintColor: mainDiver.color.toColor
                )
            }
            if let randomDiver = divers.first(
                where: {
                    $0.id.uuidString == lastMissionDiverID
                })
            {
                MissionCardView(
                    divers: divers,
                    mission: .diverMission(randomDiver),
                    tintColor: mainDiver.color.toColor
                )
            }
        }
        .padding(.bottom, 32)
        .onAppear {
            updateRandomDiverMeet()
        }
    }

    private func updateRandomDiverMeet() {
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
}

#Preview {
    MissionListView(
        mainDiver: Diver.builtin,
        divers: Diver.builtins
    )
}
