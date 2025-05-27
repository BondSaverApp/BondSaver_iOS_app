//
//  KeepLinkApp.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import BackgroundTasks
import RealmSwift
import SwiftUI

let config = Realm.Configuration(
    schemaVersion: 6,
    migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 2 {
            migration.enumerateObjects(ofType: Contact.className()) { _, newObject in
                newObject!["avatarData"] = nil
            }
        }
        if oldSchemaVersion < 3 {
            migration.enumerateObjects(ofType: User.className()) { _, newObject in
                newObject!["phoneNumber"] = ""
            }
        }
        if oldSchemaVersion < 4 {
            migration.enumerateObjects(ofType: Contact.className()) { _, newObject in
                newObject?["clientModifiedDate"] = 0
                newObject?["serverModifiedDate"] = nil
                newObject?["deleteDate"] = nil
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
        if oldSchemaVersion < 6 {
            migration.enumerateObjects(ofType: Meeting.className()) { _, newObject in
                newObject?["clientModifiedDate"] = 0
                newObject?["serverModifiedDate"] = nil
                newObject?["deleteDate"] = nil
            }
        }
    }
)

@main
struct KeepLinkApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let networkManager: NetworkManagerProtocol
    let tokenManager: TokenManager
    let authService: AuthService
    let logging: Logging
    var appViewModel: AppViewModel
    @StateObject private var networkMonitor = NetworkMonitor()

    init() {
        logging = { message in
            printLogging(message)
        }

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        tokenManager = TokenManager()
        
        networkManager =
        NetworkManager(service: APIService(urlSession: URLSession(configuration: config)),
                       tokenManager: tokenManager,
                       logging: logging)
        
        authService = AuthService(tokenManager: tokenManager, networkManager: networkManager)
        appViewModel = AppViewModel(logging: logging,
                                    authViewModel: AuthViewModel(networkManager: networkManager),
                                    signUpViewModel: SignUpViewModel(networkManager: networkManager),
                                    loginViewModel: LoginViewModel(networkManager: networkManager))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appViewModel: appViewModel)
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
                .onAppear {
                    Realm.Configuration.defaultConfiguration = config
                    scheduleReminderTask()
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
                        if let error = error {
                            print("Notification authorization error: \(error)")
                        }
                    }
                    authService.checkAuthStatus { authenticated in
                        if authenticated {
                            Task {
                                await ContactsRepository(networkManager: networkManager as! NetworkManager).syncContacts()
                            }
                        }
                    }
                }
        }
    }
}

struct AppViewModel {
    let logging: Logging
    var authViewModel: AuthViewModel
    var signUpViewModel: SignUpViewModel
    var loginViewModel: LoginViewModel
}
