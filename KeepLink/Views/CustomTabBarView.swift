//
//  CustomTabBarView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var activeTab: TabModel
    @StateObject var viewModel = CustomTabBarViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask {
                    VStack(spacing: 0) {
                        LinearGradient(
                            colors: [
                                Color.black.opacity(1),
                                Color.black.opacity(0),
                            ],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                        Rectangle()
                    }
                }
                .ignoresSafeArea()
                .frame(height: 150)
            Color(UIColor.systemBackground)
                .opacity(0.7)
                .mask {
                    VStack(spacing: 0) {
                        LinearGradient(
                            colors: [
                                Color.black.opacity(1),
                                Color.black.opacity(0),
                            ],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                        Rectangle()
                    }
                }
                .ignoresSafeArea()
                .frame(height: 150)
            HStack {
                tabBarItem(.contacts)
                tabBarItem(.profile)
                plusButton
                tabBarItem(.notifications)
                tabBarItem(.settings)
            }
            .offset(y: 50)
        }
    }

    var plusButton: some View {
        Button {
            viewModel.isSheetPresented = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
        }
        .frame(maxWidth: .infinity)
        .offset(y: -20)
        .fullScreenCover(isPresented: $viewModel.isSheetPresented) {
            ContactAddView(isPresented: $viewModel.isSheetPresented)
        }
    }

    func tabBarItem(_ tab: TabModel) -> some View {
        Button {
            activeTab = tab
        } label: {
            VStack {
                Image(systemName: tab.rawValue)
                    .font(.title2)
                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .contentShape(Rectangle())
            .foregroundStyle(activeTab == tab ? Color.accentColor : Color.accentColor.opacity(0.2))
            .padding(5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem: Identifiable {
    let id = UUID()

    let name: String?
    let image: String
}

#Preview {
    @Previewable @State var active: TabModel = .contacts
    HStack {
        Color.black
        Color.white
    }
    .ignoresSafeArea()
    .overlay {
        VStack {
            Spacer()
            CustomTabBarView(activeTab: $active)
        }
    }
}
