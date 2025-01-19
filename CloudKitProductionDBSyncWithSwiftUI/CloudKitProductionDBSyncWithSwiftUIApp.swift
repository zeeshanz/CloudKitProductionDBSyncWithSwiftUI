//
//  CloudKitProductionDBSyncWithSwiftUIApp.swift
//  CloudKitProductionDBSyncWithSwiftUI
//
//  Created by Zeeshan A Zakaria on 2025-01-19.
//

import SwiftUI
import UserNotifications
import CloudKit

@main
struct LawnAndSnowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear() {
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
    }
}
