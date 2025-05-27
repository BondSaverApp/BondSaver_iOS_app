//
//  AuthService.swift
//  KeepLink
//
//  Created by Maria Mayorova on 07.05.2025.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    private let tokenManager: TokenManager
    private let networkManager: NetworkManagerProtocol

    init(tokenManager: TokenManager, networkManager: NetworkManagerProtocol) {
        self.tokenManager = tokenManager
        self.networkManager = networkManager
    }

    func checkAuthStatus(completion: @escaping (Bool) -> Void) {
        if let accessToken = tokenManager.getAccessToken(), tokenManager.isAccessTokenValid() {
            completion(true)
            return
        }
        if let refreshToken = tokenManager.getRefreshToken(), tokenManager.isRefreshTokenValid() {
            networkManager.refreshToken(refreshToken: refreshToken) { [weak self] result in
                completion(result)
            }
            return
        }
        completion(false)
    }
}
