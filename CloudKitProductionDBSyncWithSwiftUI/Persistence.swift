//
//  Persistence.swift
//  CloudKitProductionDBSyncWithSwiftUI
//
//  Created by Zeeshan A Zakaria on 2025-01-19.
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MyDatabase")   // Database entity on the local device
        guard let store = container.persistentStoreDescriptions.first else {
            fatalError("No persistent store description found.")
        }
        let storesURL = store.url!.deletingLastPathComponent()
        store.url = storesURL.appendingPathComponent("public.sqlite")
        store.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        store.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        store.cloudKitContainerOptions?.databaseScope = .public

        let database = CKContainer(identifier: CLOUD_KIT).publicCloudDatabase

        database.fetchAllSubscriptions { subscriptions, error in
            if let error = error {
                print("Error 12354 Failed to fetch subscriptions: \(error.localizedDescription)")
                return
            }
            
            // Check if the subscription already exists
            if subscriptions?.contains(where: { $0.subscriptionID == SUBSCRIPTION_ID }) == false {
                let subscription = CKQuerySubscription(
                    recordType: "CD_Item",
                    predicate: NSPredicate(value: true),
                    subscriptionID: SUBSCRIPTION_ID,
                    options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate]
                )
                
                let notification = CKSubscription.NotificationInfo()
                notification.shouldSendContentAvailable = true
                notification.alertBody = "There's a new change in the db."
                subscription.notificationInfo = notification
                
                database.save(subscription) { result, error in
                    if let error = error {
                        print("Error 12355 saving subscription: \(error.localizedDescription)")
                    } else {
                        print("Subscription saved successfully: \(result?.subscriptionID ?? "Unknown")")
                    }
                }
            }
        }

        container.loadPersistentStores { [self] (storeDescription, error) in

            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
            
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        
        if inMemory {
            store.url = URL(fileURLWithPath: "/dev/null")
        }
    }
}
