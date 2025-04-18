//
//  Mission.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import Foundation

struct Mission: Identifiable {
    var id = UUID()
    var title: String
    var condition: ([Diver]) -> Bool

    static var defaultMissions: [Mission] {
        [
            Mission(
                title: "MBTI가 I인 다이버 3명 만나기",
                condition: { divers in
                    divers
                        .filter {
                            $0.infoList
                                .contains(
                                    where: {
                                        $0.title == "MBTI"
                                            && $0.description.starts(with: "I")
                                    })
                        }.count > 2
                }
            ),
            Mission(
                title: "2. 다이빙 장비",
                condition: { divers in
                    divers.count > 1
                }
            ),
            Mission(
                title: "3. 다이빙 장소",
                condition: { divers in
                    divers.count > 1
                }
            ),
        ]
    }
}
