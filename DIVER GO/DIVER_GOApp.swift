//
//  DIVER_GOApp.swift
//  DIVER GO
//
//  Created by 정희균 on 4/14/25.
//

import UIKit
import UserNotifications
import SwiftUI
import SwiftData

@main
struct DIVER_GOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: Diver.self)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Foreground 알림 수신 (AppDelegate): \(notification.request.content.title)")
        
        completionHandler([.banner, .sound, .badge, .list])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.notification.request.identifier
        let userInfo = response.notification.request.content.userInfo
        
        print("알림 응답 수신 (AppDelegate, ID: \(identifier)): \(userInfo)")
        UIApplication.shared
            .open(URL(string: "divergo://open?id=\(identifier)")!)

        completionHandler()
    }
}
