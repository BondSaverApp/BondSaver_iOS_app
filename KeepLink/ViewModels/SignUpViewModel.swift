//
//  SignUpViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 22.04.2025.
//

import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var password = ""
    @Published var passwordAgain = ""
    @Published var name = ""

    @Published var isLoading = false // Состояние для отображения индикатора загрузки
    @Published var showError = false // Состояние для отображения ошибки
    @Published var errorMessage = "" // Сообщение об ошибке

    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func createAccount(with phoneNumber: String) async {
        // Проверка паролей
        guard password == passwordAgain else {
            errorMessage = "Пароли не совпадают"
            showError = true
            return
        }

        isLoading = true // Показываем индикатор загрузки

        networkManager.signup(phoneNumber: phoneNumber,
                              password: password,
                              email: nil,
                              username: name)
        { token in
            // Обработка успешного создания аккаунта
            print("Аккаунт успешно создан: \(token)")
            // Здесь можно перейти на следующий экран, например, на главный экран приложения
        }
        isLoading = false // Скрываем индикатор загрузки
    }
}
