//
//  DIVER_GOApp.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftUI
import SwiftData

@main
struct DIVER_GOApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: Diver.self)
    }
}
