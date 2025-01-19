//
//  AppDelegate.swift
//  Lawn and Snow
//
//  Created by Dev User on 2025-01-18.
//

import UIKit
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for remote notifications")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Remote notification received")

        if CKNotification(fromRemoteNotificationDictionary: userInfo) != nil {
            print("CloudKit database changed")
            NotificationCenter.default.post(name: .CKAccountChanged, object: nil)
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
}
