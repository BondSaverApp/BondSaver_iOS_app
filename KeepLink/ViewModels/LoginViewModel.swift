//
//  LoginViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 22.04.2025.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var password = ""
    @Published var isLoading = false // Состояние для отображения индикатора загрузки
    @Published var showError = false // Состояние для отображения ошибки
    @Published var errorMessage = "" // Сообщение об ошибке
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // Функция для входа
    func login(with phoneNumber: String) async {
        isLoading = true // Показываем индикатор загрузки

        networkManager.login(phoneNumber: phoneNumber,
                             password: password) { token in
            // Обработка успешного входа
            print("Успешный вход: \(token)")
        }
        isLoading = false // Скрываем индикатор загрузки
    }
}
