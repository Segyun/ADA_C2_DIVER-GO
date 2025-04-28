//
//  MissionCardView.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
//

import SwiftUI

struct MissionCardView: View {
    let divers: [Diver]
    let mission: Mission
    let tintColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(mission.description)
                    .font(.headline)
                Spacer()
                Text("\(mission.getMissionCount(divers))/\(mission.count)")
                    .font(.subheadline)
            }
            .glassOpacity()
            .padding(.bottom)

            ProgressView(
                value: Double(mission.getMissionCount(divers))
                    / Double(
                        mission
                            .count
                    )
            )
            .tint(tintColor)
            .glassOpacity()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    MissionCardView(
        divers: Diver.builtins,
        mission: .builtin,
        tintColor: .yellow
    )
}
