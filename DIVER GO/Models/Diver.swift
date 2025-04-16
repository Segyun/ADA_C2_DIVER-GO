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

struct Diver: Identifiable, Codable, Hashable {
    var id = UUID()
    var nickname: String
    var image: Data?
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
        image: Data? = nil,
        infoList: [DiverInfo]
    ) {
        self.id = id
        self.nickname = nickname
        self.image = image
        self.infoList = infoList
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
