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
    @Binding var isLoggedIn: Bool
    
    init(appViewModel: AppViewModel,
         isLoggedIn: Binding<Bool>
    ) {
        self.appViewModel = appViewModel
        _isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        if !isLoggedIn {
            OnboardingView(appViewModel: appViewModel,
                           isLoggedIn: $isLoggedIn)
        } else {
            MainView()
        }
    }
}

//#Preview {
//    ContentView()
//}
