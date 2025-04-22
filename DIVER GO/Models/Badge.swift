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
    var id: String
    var title: String
    var description: String
    var category: BadgeCategory
    var count: Int
    var tintColor: Color

    var infoTitle: String?
    var infoDescription: String?
    
    func isCompleted(_ divers: [Diver]) -> Bool {
        return self.getBadgeCount(divers) >= self.count
    }
    
    func strokeColor(_ divers: [Diver]) -> Color {
        if self.isCompleted(divers) {
            return .C_1
        }
        return .C_3
    }
    
    static var badges: [Badge] {
        [
            Badge(
                id: "com.lemon.achievement.first_meet",
                title: "다이버 첫 만남",
                description: "다이버 1명 만나기",
                category: .any,
                count: 1,
                tintColor: .brown
            ),
            Badge(
                id: "com.lemon.achievement.diver_friend",
                title: "다이버 친구",
                description: "다이버 10명 만나기",
                category: .any,
                count: 10,
                tintColor: .gray
            ),
            Badge(
                id: "com.lemon.achievement.diver_bf",
                title: "다이버 베프",
                description: "다이버 50명 만나기",
                category: .any,
                count: 50,
                tintColor: .yellow
            ),
            Badge(
                id: "com.lemon.achievement.celeb",
                title: "다이버 셀럽",
                description: "다이버 100명 만나기",
                category: .any,
                count: 100,
                tintColor: .C_2
            ),
            Badge(
                id: "com.lemon.achievement.infj_collector",
                title: "INFJ 콜렉터",
                description: "INFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INFJ"
            ),
            Badge(
                id: "com.lemon.achievement.infp_collector",
                title: "INFP 콜렉터",
                description: "INFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INFP"
            ),
            Badge(
                id: "com.lemon.achievement.intj_collector",
                title: "INTJ 콜렉터",
                description: "INTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INTJ"
            ),
            Badge(
                id: "com.lemon.achievement.intp_collector",
                title: "INTP 콜렉터",
                description: "INTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "INTP"
            ),
            Badge(
                id: "com.lemon.achievement.isfj_collector",
                title: "ISFJ 콜렉터",
                description: "ISFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISFJ"
            ),
            Badge(
                id: "com.lemon.achievement.isfp_collector",
                title: "ISFP 콜렉터",
                description: "ISFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISFP"
            ),
            Badge(
                id: "com.lemon.achievement.istj_collector",
                title: "ISTJ 콜렉터",
                description: "ISTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISTJ"
            ),
            Badge(
                id: "com.lemon.achievement.istp_collector",
                title: "ISTP 콜렉터",
                description: "ISTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .orange,
                infoTitle: "MBTI",
                infoDescription: "ISTP"
            ),
            Badge(
                id: "com.lemon.achievement.enfj_collector",
                title: "ENFJ 콜렉터",
                description: "ENFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENFJ"
            ),
            Badge(
                id: "com.lemon.achievement.enfp_collector",
                title: "ENFP 콜렉터",
                description: "ENFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENFP"
            ),
            Badge(
                id: "com.lemon.achievement.entj_collector",
                title: "ENTJ 콜렉터",
                description: "ENTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENTJ"
            ),
            Badge(
                id: "com.lemon.achievement.entp_collector",
                title: "ENTP 콜렉터",
                description: "ENTP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ENTP"
            ),
            Badge(
                id: "com.lemon.achievement.esfj_collector",
                title: "ESFJ 콜렉터",
                description: "ESFJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESFJ"
            ),
            Badge(
                id: "com.lemon.achievement.esfp_collector",
                title: "ESFP 콜렉터",
                description: "ESFP 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESFP"
            ),
            Badge(
                id: "com.lemon.achievement.estj_collector",
                title: "ESTJ 콜렉터",
                description: "ESTJ 다이버 10명 만나기",
                category: .mbti,
                count: 10,
                tintColor: .teal,
                infoTitle: "MBTI",
                infoDescription: "ESTJ"
            ),
            Badge(
                id: "com.lemon.achievement.estp_collector",
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
