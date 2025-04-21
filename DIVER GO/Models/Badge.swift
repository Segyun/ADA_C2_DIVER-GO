//
//  Badge.swift
//  DIVER GO
//
//  Created by 정희균 on 4/21/25.
//

import SwiftUI

enum BadgeCategory {
    case any
    case diver
    case mbti
    case learningType
}

struct Badge: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var category: BadgeCategory
    var count: Int
    var tintColor: Color

    var infoTitle: String?
    var infoDescription: String?
    
    func strokeColor(_ divers: [Diver]) -> Color {
        if self.getBadgeCount(divers) >= self.count {
            return .C_1
        }
        return .C_3
    }
    
    static var badges: [Badge] {
        [
            Badge(
                title: "다이버 첫 만남",
                description: "다이버 1명 만나기",
                category: .any,
                count: 1,
                tintColor: .brown
            ),
            Badge(
                title: "다이버 친구",
                description: "다이버 10명 만나기",
                category: .any,
                count: 10,
                tintColor: .gray
            ),
            Badge(
                title: "다이버 베프",
                description: "다이버 50명 만나기",
                category: .any,
                count: 50,
                tintColor: .yellow
            ),
            Badge(
                title: "다이버 셀럽",
                description: "다이버 100명 만나기",
                category: .any,
                count: 100,
                tintColor: .C_2
            ),
            Badge(
                title: "INFJ 콜렉터",
                description: "INFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INFJ"
            ),
            Badge(
                title: "INFP 콜렉터",
                description: "INFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INFP"
            ),
            Badge(
                title: "INTJ 콜렉터",
                description: "INTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INTJ"
            ),
            Badge(
                title: "INTP 콜렉터",
                description: "INTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INTP"
            ),
            Badge(
                title: "ISFJ 콜렉터",
                description: "ISFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISFJ"
            ),
            Badge(
                title: "ISFP 콜렉터",
                description: "ISFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISFP"
            ),
            Badge(
                title: "ISTJ 콜렉터",
                description: "ISTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISTJ"
            ),
            Badge(
                title: "ISTP 콜렉터",
                description: "ISTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISTP"
            ),
            // E로 시작 (tintColor: .teal)
            Badge(
                title: "ENFJ 콜렉터",
                description: "ENFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENFJ"
            ),
            Badge(
                title: "ENFP 콜렉터",
                description: "ENFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENFP"
            ),
            Badge(
                title: "ENTJ 콜렉터",
                description: "ENTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENTJ"
            ),
            Badge(
                title: "ENTP 콜렉터",
                description: "ENTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENTP"
            ),
            Badge(
                title: "ESFJ 콜렉터",
                description: "ESFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESFJ"
            ),
            Badge(
                title: "ESFP 콜렉터",
                description: "ESFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESFP"
            ),
            Badge(
                title: "ESTJ 콜렉터",
                description: "ESTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESTJ"
            ),
            Badge(
                title: "ESTP 콜렉터",
                description: "ESTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESTP"
            )
        ]
    }
    
    func getBadgeCount(_ divers: [Diver]) -> Int {
        var count = 0

        switch self.category {
        case .any:
            count = divers.count
        case .diver:
            count = divers
                .count { $0.nickname == infoDescription }
        case .learningType:
            count = divers.count {
                $0.infoList.filter {
                    $0.title == "관심 분야" && $0.description == infoDescription
                }.isEmpty == false
            }
        case .mbti:
            count = divers.count {
                $0.infoList.filter {
                    $0.title == "MBTI" && $0.description == infoDescription
                }.isEmpty == false
            }
        }

        if count > self.count {
            count = self.count
        }

        return count
    }
}
