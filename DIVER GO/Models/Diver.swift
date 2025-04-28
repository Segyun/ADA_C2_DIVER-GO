//
//  Diver.swift
//  DIVER GO
//
//  Created by 정희균 on 4/15/25.
//

import SwiftData
import SwiftUI

@Model
class Diver: Codable {
    var id = UUID()
    var nickname: String = ""
    var emoji: String = ""
    var color: DiverColor = DiverColor.yellow
    var infoList: [DiverInfo] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init() {
        self.nickname = ""
        self.emoji = ""
        self.infoList = DiverInfo.defaultInfo
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    init(_ nickname: String, emoji: String, isDefaultInfo: Bool = true) {
        self.nickname = nickname
        self.emoji = emoji
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
        color: DiverColor,
        infoList: [DiverInfo] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.nickname = nickname
        self.emoji = emoji
        self.color = color
        self.infoList = infoList
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case id
        case nickname
        case emoji
        case color
        case infoList
        case createdAt
        case updatedAt
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.color = try container.decode(DiverColor.self, forKey: .color)
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
        try container.encode(color, forKey: .color)
        try container.encode(infoList, forKey: .infoList)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

extension Diver {
    static var builtin: Diver { Diver("Lemon", emoji: "🍋") }

    static var builtins: [Diver] {
        [
            Diver("Lemon", emoji: "🍋"),
            Diver("Apple", emoji: "🍎"),
            Diver("Banana", emoji: "🍌"),
            Diver("Grape", emoji: "🍇"),
            Diver("Orange", emoji: "🍊"),
            Diver("Peach", emoji: "🍑"),
            Diver("Watermelon", emoji: "🍉"),
            Diver("Pineapple", emoji: "🍍"),
        ]
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
}

extension Diver {
    func toURL() -> URL {
        var url = "divergo://share?"

        guard let diverJSON = try? JSONEncoder().encode(self) else {
            return URL(string: url)!
        }

        let diverBase64 = diverJSON.base64EncodedString()

        url += "diver=\(diverBase64)"

        return URL(string: url)!
    }
}
