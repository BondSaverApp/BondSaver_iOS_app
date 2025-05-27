//
//  AuthViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 22.04.2025.
//

import SwiftUI

final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var isAccountExists: Bool = false // Состояние для управления переходом
    @Published var isLoading = false // Состояние для отображения индикатора загрузки
    @Published var navigate: Bool = false
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func checkAccountExists() {
        networkManager.checkAccount(email: email) { [weak self] isExists in
            print("Network response: \(isExists)")
            DispatchQueue.main.async {
                self?.isAccountExists = isExists
                self?.navigate = true
            }
        }
    }
}
