//
//  ContentView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connectionType) private var connectionType
    var appViewModel: AppViewModel
    @State private var isLoggedIn: Bool = false

    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    var body: some View {
        if !isLoggedIn {
            OnboardingView(appViewModel: appViewModel,
                           isLoggedIn: $isLoggedIn)
        } else {
            MainView()
//            NavigationStack {
//                List {
//                    Section ("Status") {
//                        Text((isConnected ?? false) ? "Connected" : "No internet")
//                    }
//
//                    if let connectionType {
//                        Section {
//                            Text(String(describing: connectionType).capitalized)
//                        }
//                    }
//                }
//                .navigationTitle(Text("NetworkMonitor"))
//            }
        }
    }
}

// #Preview {
//    ContentView()
// }
