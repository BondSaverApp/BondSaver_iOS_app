//
//  KeepLinkApp.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

@main
struct KeepLinkApp: App {
    
    @StateObject var tabBarState = TabBarState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tabBarState)
        }
    }
}
