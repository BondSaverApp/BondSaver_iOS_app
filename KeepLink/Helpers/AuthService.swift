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

    @Published var isAuthentificated: Bool = false {
        didSet {
            print("isAuthentificated: \(isAuthentificated)")
        }
    }

    func checkAuthStatus(completion: @escaping (Bool) -> Void) {
        if let accessToken = tokenManager.getAccessToken(), tokenManager.isAccessTokenValid() {
            isAuthentificated = true
            completion(true)
            return
        }
        if let refreshToken = tokenManager.getRefreshToken(), tokenManager.isRefreshTokenValid() {
            networkManager.refreshToken(refreshToken: refreshToken) { [weak self] result in
                self?.isAuthentificated = result
                completion(result)
            }
            return
        }
        completion(false)
    }
}
