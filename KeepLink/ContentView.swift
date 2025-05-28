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
    var authService: any AuthServiceProtocol
    @State private var isLoggedIn: Bool = false {
        didSet {
            authService.checkAuthStatus { _ in }
        }
    }

    init(appViewModel: AppViewModel, authService: any AuthServiceProtocol) {
        self.appViewModel = appViewModel
        self.authService = authService
    }

    var body: some View {
        if authService.isAuthentificated || isLoggedIn {
            MainView()
        } else {
            OnboardingView(appViewModel: appViewModel,
                           isLoggedIn: $isLoggedIn)
        }
    }
}

// #Preview {
//    ContentView()
// }
