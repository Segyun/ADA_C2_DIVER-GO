//
//  Diver.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftUI
import SwiftData

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
        isRequired: Bool = false
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

@Model
class Diver: Codable {
    enum CodingKeys: CodingKey {
        case id
        case nickname
        case emoji
        case infoList
        case createdAt
        case updatedAt
    }

    var id = UUID()
    var nickname: String
    var emoji: String
    var infoList: [DiverInfo] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init() {
        self.nickname = ""
        self.emoji = ""
    }

    init(_ nickname: String, isDefaultInfo: Bool = true) {
        self.nickname = nickname
        self.emoji = ""
        if isDefaultInfo {
            self.infoList = DiverInfo.defaultInfo
        } else {
            self.infoList = []
        }
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    init(
        id: UUID = UUID(),
        nickname: String,
        emoji: String,
        infoList: [DiverInfo] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.nickname = nickname
        self.emoji = emoji
        self.infoList = infoList
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.infoList = try container.decode(
            [DiverInfo].self,
            forKey: .infoList
        )
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(infoList, forKey: .infoList)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }

    func toURL() -> URL {
        var url = "divergo://open?"

        url += "\(CodingKeys.id.stringValue)=\(id)"
        url += "&\(CodingKeys.nickname.stringValue)=\(nickname)"
        url += "&\(CodingKeys.emoji.stringValue)=\(emoji)"
        url += "&\(CodingKeys.createdAt.stringValue)=\(createdAt.toString())"
        url += "&\(CodingKeys.updatedAt.stringValue)=\(updatedAt.toString())"

        for info in infoList {
            url += "&\(info.title)=\(info.description)"
        }

        return URL(string: url)!
    }
    
    func getStrokeColor(_ mainDiver: Diver) -> Color {
        if self.id == mainDiver.id {
            return .C_1
        }
        
        let dateComponents = Calendar.current
            .dateComponents([.day], from: self.updatedAt, to: Date())
        
        if let days = dateComponents.day, days < 1 {
            return .C_2
        }
        return .C_3
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
