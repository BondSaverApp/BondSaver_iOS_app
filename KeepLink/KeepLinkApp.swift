//
//  KeepLinkApp.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI
import RealmSwift

let config = Realm.Configuration(
    schemaVersion: 5,
    migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 2 {
            migration.enumerateObjects(ofType: Contact.className()) { oldObject, newObject in
                newObject!["avatarData"] = nil
            }
        }
        if oldSchemaVersion < 3 {
            migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
                newObject!["phoneNumber"] = ""
            }
        }
        if oldSchemaVersion < 5 {
            migration.enumerateObjects(ofType: Meeting.className()) { _, newObject in
                newObject!["topics"] = RealmSwift.List<Topic>()
            }
            migration.enumerateObjects(ofType: Topic.className()) { _, newObject in
                newObject!["meetings"] = nil
            }
        }
    }
)

@main
struct KeepLinkApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Realm.Configuration.defaultConfiguration = config
                }
        }
    }
}
