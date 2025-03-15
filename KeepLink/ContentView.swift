//
//  ContentView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
//        if !isLoggedIn {
//            OnboardingView(isLoggedIn: $isLoggedIn)
//        } else {
            MainView()
//        }
    }
}

#Preview {
    ContentView()
}
