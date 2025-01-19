Tested on Xcode 15 and iOS 17. (Eaerly 2025)

While syncing with CloudKit's private database is pretty simple, but syncing with its public database can be a nightmare. It is even harder to do it in SwiftUI. There is no clear guidance on how to implement CloudKit to iOS realtime sync when using public database.

This code shows how to to do this successfully. Just replace in `Constants.swift` the name of your CloudKit container whose public database you want to sync. Do the same in the `CloudKitProductionDBSyncWithSwiftUI.entitlements` file.

Also update the Builder Identifier to your app's identifier.
