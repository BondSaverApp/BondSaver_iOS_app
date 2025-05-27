//
//  TokenManager.swift
//  KeepLink
//
//  Created by Maria Mayorova on 07.05.2025.
//

import Foundation
import KeychainSwift

final class TokenManager {
    private let keychain = KeychainSwift()

    private enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let accessTokenExpiry = "accessTokenExpiry"
        static let refreshTokenExpiry = "refreshTokenExpiry"
    }

    func saveTokens(accessToken: String?, refreshToken: String?, accessTokenExpiry: Int?, refreshTokenExpiry: Int?) {
        if let accessToken = accessToken {
            keychain.set(accessToken, forKey: Keys.accessToken)
        }
        if let refreshToken = refreshToken {
            keychain.set(refreshToken, forKey: Keys.refreshToken)
        }
        if let accessTokenExpiry = accessTokenExpiry {
            keychain.set(Date().addingTimeInterval(Double(accessTokenExpiry)).timeIntervalSince1970.description, forKey: Keys.accessTokenExpiry)
        }
        if let refreshTokenExpiry = refreshTokenExpiry {
            keychain.set(Date().addingTimeInterval(Double(refreshTokenExpiry)).timeIntervalSince1970.description, forKey: Keys.refreshTokenExpiry)
        }
    }

    // MARK: Получение токенов

    func getAccessToken() -> String? {
        return keychain.get(Keys.accessToken)
    }

    func getRefreshToken() -> String? {
        return keychain.get(Keys.refreshToken)
    }

    func isAccessTokenValid() -> Bool {
        guard let expiryString = keychain.get(Keys.accessTokenExpiry),
              let expiryTimeInterval = TimeInterval(expiryString)
        else {
            return false
        }
        return Date().timeIntervalSince1970 < expiryTimeInterval
    }

    func isRefreshTokenValid() -> Bool {
        guard let expiryString = keychain.get(Keys.refreshTokenExpiry),
              let expiryTimeInterval = TimeInterval(expiryString)
        else {
            return false
        }
        return Date().timeIntervalSince1970 < expiryTimeInterval
    }

    func clearTokens() {
        keychain.delete(Keys.accessToken)
        keychain.delete(Keys.refreshToken)
        keychain.delete(Keys.accessTokenExpiry)
        keychain.delete(Keys.refreshTokenExpiry)
    }
}

extension TokenManager {}
