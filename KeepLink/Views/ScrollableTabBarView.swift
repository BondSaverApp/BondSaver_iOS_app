//
//  ScrollableTabBarView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 15.02.2025.
//

import SwiftUI

struct TabHeader: View {
    @Binding var activeTab: ContactMainTab

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(ContactMainTab.allCases) { tab in
                        Button(action: {
                            withAnimation(.snappy) {
                                activeTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(.body)
                                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                        }
                        .buttonStyle(.plain)
                    }
                }

                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 2)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width / CGFloat(ContactMainTab.allCases.count), height: 2)
                        .offset(x: activeTab == .info ? 0 : geometry.size.width / CGFloat(ContactMainTab.allCases.count))
                        .animation(.snappy, value: activeTab)
                }
                .padding(.top, 15)
            }
        }
        .frame(height: 57)
    }
}

struct TabHeader_Previews: PreviewProvider {
    @State static var tab: ContactMainTab = .info

    static var previews: some View {
        TabHeader(activeTab: $tab)
    }
}
