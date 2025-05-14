//
//  ScrollableTabBarModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 15.02.2025.
//

import SwiftUI

enum ContactMainTab: String, CaseIterable, Identifiable {
    case info = "О контакте"
    case meetings = "Встречи"

    var id: String { rawValue }
}
