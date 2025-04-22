//
//  Diver.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftData
import SwiftUI

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

    var description: String {
        return """
            Diver(
                id: \(id),
                nickname: \(nickname),
                emoji: \(emoji),
                infoList: \(infoList),
                createdAt: \(createdAt),
                updatedAt: \(updatedAt)
            )
            """
    }

    func toURL() -> URL {
        var url = "divergo://share?"

        guard let diverJSON = try? JSONEncoder().encode(self) else {
            return URL(string: url)!
        }

        #if DEBUG
            print(
                "Diver JSON: \(String(data: diverJSON, encoding: .utf8) ?? "")"
            )
        #endif

        let diverBase64 = diverJSON.base64EncodedString()

        url += "diver=\(diverBase64)"

        #if DEBUG
            print("Diver URL(\(url.count)): \(url)")
        #endif

        return URL(string: url)!
    }

    func getStrokeColor(_ mainDiver: Diver) -> Color {
        if self.id == mainDiver.id {
            return .C_1
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        let updatedDate = dateFormatter.string(from: self.updatedAt)
        let todayDate = dateFormatter.string(from: Date())
        
        if updatedDate == todayDate {
            return .C_2
        }
        return .C_5
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
