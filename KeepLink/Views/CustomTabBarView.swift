//
//  CustomTabBarView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var activeTab: TabModel
    @State var isSheetPresented: Bool = false
    
    var body: some View {
        HStack {
            tabBarItem(.contacts)
            tabBarItem(.settings)
            plusButton
            tabBarItem(.notifications)
            tabBarItem(.profile)
        }
    }
    
    var plusButton: some View {
        Button {
            isSheetPresented = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .offset(y: -20)
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $isSheetPresented) {
            ContactAddView(isShowSheet: $isSheetPresented)
        }
    }
    
    func tabBarItem(_ tab: TabModel) -> some View{
        Button {
            activeTab = tab
        } label: {
            VStack {
                Image(systemName: tab.rawValue)
                    .font(.title2)
                    .frame(width: 30, height: 30)
            }
            .foregroundStyle(activeTab == tab ? Color.accentColor : Color.accentColor.opacity(0.2))
            .padding(5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem: Identifiable{
    let id = UUID()
    
    let name: String?
    let image: String
}

#Preview {
    ContentView()
}
