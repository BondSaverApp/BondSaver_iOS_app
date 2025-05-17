//
//  MainView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.02.2025.
//

import RealmSwift
import SwiftUI

struct MainView: View {
    @State private var activeTab: TabModel = .contacts
    @State private var isTabBarHidden = false

    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                TabView(selection: $activeTab) {
                    Tab(value: .contacts) {
                        ContactsView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .settings) {
                        SettingsView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .notifications) {
                        NotificationsView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .profile) {
                        MeetingsView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    ContactsView()
                        .tag(TabModel.contacts)
                    Text("Settings")
                        .tag(TabModel.settings)
                    Text("Notifications")
                        .tag(TabModel.notifications)
                    MeetingsView()
                        .tag(TabModel.profile)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !isTabBarHidden {
                CustomTabBarView(activeTab: $activeTab)
            }
        }
        .animation(.none, value: isTabBarHidden)
        .environment(\.tabBarHidden, $isTabBarHidden)
    }
}
