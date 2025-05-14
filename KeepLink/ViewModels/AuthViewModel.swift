//
//  AuthViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 22.04.2025.
//

import SwiftUI

final class AuthViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var isAccountExists: Bool? = nil // Состояние для управления переходом
    @Published var isLoading = false // Состояние для отображения индикатора загрузки

    let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func checkAccountExists() {
        networkManager.checkAccount(phoneNumber: phoneNumber) { [weak self] isExists in
            DispatchQueue.main.async {
                self?.isAccountExists = isExists
            }
        }
    }
}
