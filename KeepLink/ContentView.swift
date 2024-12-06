//
//  ContentView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabModel = .contacts
    @State private var isTabBarHidden: Bool = false
    
    var body: some View {
        Group {
            if #available(iOS 18.0, *){
                TabView(selection: $activeTab){
                    Tab(value: .contacts) {
                        ContactsView()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .settings) {
                        Text("Settings")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .notifications) {
                        Text("Notifications")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: .profile) {
                        Text("Profile")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    ContactsView()
                        .tag(TabModel.contacts)
                        .background {
                            if !isTabBarHidden{
                                HideTabBar {
                                    isTabBarHidden = true
                                }
                            }
                        }
                    Text("Settings")
                        .tag(TabModel.settings)
                    Text("Notifications")
                        .tag(TabModel.notifications)
                    Text("Profile")
                        .tag(TabModel.profile)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBarView(activeTab: $activeTab)
        }
    }
}

#Preview {
    ContentView()
}
