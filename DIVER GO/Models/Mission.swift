//
//  Mission.swift
//  DIVER GO
//
//  Created by 정희균 on 4/16/25.
//

import Foundation

enum MissionCategory {
    case any
    case diver
    case mbti
    case learningType
}

struct Mission: Identifiable {
    var id = UUID()
    var description: String
    var category: MissionCategory
    var count: Int

    var infoTitle: String?
    var infoDescription: String?

    func getMissionCount(_ divers: [Diver]) -> Int {
        guard
            let date = Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: Date()
                )
            )
        else { return 0 }

        var count = 0

        switch self.category {
        case .any:
            count = divers.count { $0.updatedAt > date }
        case .diver:
            count = divers
                .count { $0.nickname == infoDescription && $0.updatedAt > date }
        case .learningType:
            count = divers.count {
                $0.infoList.filter {
                    $0.title == "관심 분야" && $0.description == infoDescription
                }.isEmpty == false && $0.updatedAt > date
            }
        case .mbti:
            count = divers.count {
                $0.infoList.filter {
                    $0.title == "MBTI" && $0.description == infoDescription
                }.isEmpty == false && $0.updatedAt > date
            }
        }

        if count > self.count {
            count = self.count
        }

        return count
    }
    
    static func diverMission(_ diver: Diver) -> Mission {
        Mission(
            description: "'\(diver.nickname)' 다이버 만나기",
            category: .diver,
            count: 1,
            infoTitle: diver.nickname,
            infoDescription: diver.nickname
        )
    }

    static var builtin: Mission {
        Mission(
            description: "아무 다이버 1명 만나기",
            category: .any,
            count: 1
        )
    }

    static var mbtiMission: [Mission] {
        [
            Mission(
                description: "'MBTI'가 'INTP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "INTP"
            ),
            Mission(
                description: "'MBTI'가 'INTJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "INTJ"
            ),
            Mission(
                description: "'MBTI'가 'ENTP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ENTP"
            ),
            Mission(
                description: "'MBTI'가 'ENTJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ENTJ"
            ),
            Mission(
                description: "'MBTI'가 'INFJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "INFJ"
            ),
            Mission(
                description: "'MBTI'가 'INFP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "INFP"
            ),
            Mission(
                description: "'MBTI'가 'ENFJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ENFJ"
            ),
            Mission(
                description: "'MBTI'가 'ENFP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ENFP"
            ),
            Mission(
                description: "'MBTI'가 'ISTJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ISTJ",
            ),
            Mission(
                description: "'MBTI'가 'ISFJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ISFJ"
            ),
            Mission(
                description: "'MBTI'가 'ESTJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ESTJ"
            ),
            Mission(
                description: "'MBTI'가 'ESFJ'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ESFJ"
            ),
            Mission(
                description: "'MBTI'가 'ISTP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ISTP"
            ),
            Mission(
                description: "'MBTI'가 'ISFP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ISFP"
            ),
            Mission(
                description: "'MBTI'가 'ESTP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ESTP"
            ),
            Mission(
                description: "'MBTI'가 'ESFP'인 다이버 1명 만나기",
                category: .mbti,
                count: 1,
                infoTitle: "MBTI",
                infoDescription: "ESFP"
            ),
        ]
    }
}

extension Array {
    func stableRandom(using date: Date = Date()) -> Element? {
        guard !isEmpty else { return nil }
        let day = Calendar.current.component(.day, from: date)
        let index = day % count
        return self[index]
    }
}
