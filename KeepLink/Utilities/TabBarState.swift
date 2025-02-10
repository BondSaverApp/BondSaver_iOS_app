//
//  TabBarState.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import SwiftUI

private struct TabBarStateKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var tabBarIsVisible: Bool {
        get { self[TabBarStateKey.self] }
        set { self[TabBarStateKey.self] = newValue }
    }
}
