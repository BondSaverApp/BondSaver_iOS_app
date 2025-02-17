//
//  ContentView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
//        if !isLoggedIn {
//            OnboardingView()
//        } else {
            MainView()
//        }
    }
}

#Preview {
    ContentView()
}
