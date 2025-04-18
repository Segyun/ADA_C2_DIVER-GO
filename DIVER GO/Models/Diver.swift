//
//  Diver.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import Foundation

struct DiverInfo: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var isRequired: Bool = false

    init() {
        self.title = ""
        self.description = ""
    }

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isRequired: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isRequired = isRequired
    }

    static var defaultInfo: [DiverInfo] {
        [
            DiverInfo(title: "관심 분야", description: "", isRequired: true),
            DiverInfo(title: "MBTI", description: "", isRequired: true),
            DiverInfo(
                title: "연락처",
                description: "",
                isRequired: true
            ),
        ]
    }
}

enum DiverQuery: String {
    case ID = "id"
    case NICKNAME = "nickname"
    case EMOJI = "emoji"
    case CREATED_AT = "createdAt"
    case UPDATED_AT = "updatedAt"
}

struct Diver: Identifiable, Codable, Hashable {
    var id = UUID()
    var nickname: String
    var emoji: String = ""
    var infoList: [DiverInfo] = DiverInfo.defaultInfo
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init() {
        self.nickname = ""
    }

    init(_ nickname: String) {
        self.nickname = nickname
    }

    init(
        id: UUID = UUID(),
        nickname: String,
        emoji: String = "",
        infoList: [DiverInfo]
    ) {
        self.id = id
        self.nickname = nickname
        self.emoji = emoji
        self.infoList = infoList
    }
    
    func toURL() -> URL {
        var url = "divergo://open?"
        
        url += "\(DiverQuery.ID.rawValue)=\(id)"
        url += "&\(DiverQuery.NICKNAME.rawValue)=\(nickname)"
        url += "&\(DiverQuery.EMOJI.rawValue)=\(emoji)"
        url += "&\(DiverQuery.CREATED_AT.rawValue)=\(createdAt.toString())"
        url += "&\(DiverQuery.UPDATED_AT.rawValue)=\(updatedAt.toString())"
        
        for info in infoList {
            url += "&\(info.title)=\(info.description)"
        }
        
        return URL(string: url)!
    }

    static var builtin: Diver { Diver("Lemon") }

    static var builtins: [Diver] {
        [
            Diver("Lemon"),
            Diver("Apple"),
            Diver("Banana"),
            Diver("Grape"),
            Diver("Orange"),
            Diver("Peach"),
            Diver("Watermelon"),
            Diver("Pineapple"),
        ]
    }
}
