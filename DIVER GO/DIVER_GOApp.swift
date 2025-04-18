//
//  DIVER_GOApp.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @ObservedObject private var diverStore = DiverStore.shared

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let url = connectionOptions.urlContexts.first?.url else {
            return
        }

        let urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        let urlQueryItems = urlComponents?.queryItems ?? []

        diverStore.getSharedDiver(urlQueryItems)
    }

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else {
            return
        }

        let urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        let urlQueryItems = urlComponents?.queryItems ?? []

        diverStore.getSharedDiver(urlQueryItems)
    }
}

@main
struct DIVER_GOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
