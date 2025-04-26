//
//  DiverInfo.swift
//  DIVER GO
//
//  Created by 정희균 on 4/26/25.
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

    init(_ title: String) {
        self.title = title
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
}

extension DiverInfo {
    static var defaultInfo: [DiverInfo] {
        [
            DiverInfo(title: "세션", description: "오전", isRequired: true),
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
