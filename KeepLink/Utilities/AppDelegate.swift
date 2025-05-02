//
//  AppDelegate.swift
//  KeepLink
//
//  Created by Андрей Степанов on 02.05.2025.
//

import BackgroundTasks
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        registerBackgroundTasks() // Вызов из BGTasks.swift
        print("✅ BGTask registered at launch")
        return true
    }
}
