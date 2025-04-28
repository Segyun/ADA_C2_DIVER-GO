//
//  DIVER_GOApp.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import GameKit
import SwiftData
import SwiftUI
import UIKit
import UserNotifications

@main
struct DIVER_GOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let container: ModelContainer
    
    init() {
        let modelConfiguration = ModelConfiguration(cloudKitDatabase: .none)
//        let modelConfiguration = ModelConfiguration(cloudKitDatabase: .private("iCloud.divergo.lemon.com.Diver"))
        
        do {
            container = try ModelContainer(
                for: Diver.self,
                configurations: modelConfiguration
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        
        if !GKLocalPlayer.local.isAuthenticated {
            GKLocalPlayer.local.authenticateHandler = { _, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
            }
        }
        GKAccessPoint.shared.location = .bottomTrailing
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(container)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate,
    UNUserNotificationCenterDelegate
{
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        print(
            "Foreground 알림 수신 (AppDelegate): \(notification.request.content.title)"
        )

        completionHandler([.banner, .sound, .badge, .list])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        let userInfo = response.notification.request.content.userInfo

        print("알림 응답 수신 (AppDelegate, ID: \(identifier)): \(userInfo)")
        UIApplication.shared
            .open(URL(string: "divergo://open?id=\(identifier)")!)

        completionHandler()
    }
}
