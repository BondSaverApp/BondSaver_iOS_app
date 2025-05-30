//
//  NetworkManager.swift
//  KeepLink
//
//  Created by Maria Mayorova on 18.04.2025.
//

import Foundation
import KeychainSwift

struct NetworkManager: NetworkManagerProtocol {
    let tokenManager: TokenManager
    private let service: APIService
    let logging: Logging

    init(service: APIService, tokenManager: TokenManager, logging: @escaping Logging) {
        self.service = service
        self.tokenManager = tokenManager
        self.logging = logging
    }

    // MARK: - Check account existence

    func checkAccount(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.checkAccount(phoneNumber: phoneNumber).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: CheckAccountResponse.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            print(response?.exists as Any)
            completion(response?.exists ?? false)
        }
    }

    // MARK: - Sign up

    func signup(phoneNumber: String, password: String, email: String?, username: String, completion: @escaping (String) -> Void) {
        guard let request = Endpoint.userSignup(
            phoneNumber: phoneNumber,
            password: password,
            email: email,
            username: username
        ).request else {
            logging("Error: Failed to create request")
            completion("")
            return
        }

        service.makeRequestWithCookies(with: request, respModel: AuthResponse.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }

            tokenManager.saveTokens(accessToken: response?.accessToken, refreshToken: response?.refreshToken, accessTokenExpiry: response?.accessTokenDuration, refreshTokenExpiry: response?.refreshTokenDuration)

            completion(response?.accessToken ?? "")
        }
    }

    // MARK: - Login

    func login(phoneNumber: String, password: String, completion: @escaping (String) -> Void) {
        guard let request = Endpoint.userLogin(phoneNumber: phoneNumber, password: password).request else {
            logging("Error: Failed to create request")
            completion("")
            return
        }

        service.makeRequestWithCookies(with: request, respModel: AuthResponse.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }
            tokenManager.saveTokens(accessToken: response?.accessToken, refreshToken: response?.refreshToken, accessTokenExpiry: response?.accessTokenDuration, refreshTokenExpiry: response?.refreshTokenDuration)

            completion(response?.accessToken ?? "")
        }
    }

    // MARK: - Refresh token

    func refreshToken(refreshToken: String = "", completion: @escaping (Bool) -> Void) {
        let tokenToSend = tokenManager.getRefreshToken() ?? ""
        guard var request = Endpoint.refreshToken(refreshToken: tokenToSend).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            var refreshToken = refreshToken
            if refreshToken == "" {
                let keychain = KeychainSwift()
                refreshToken = keychain.get("accessToken") ?? ""
            }

            request.addCookies(["refreshToken": refreshToken])
            completion(true)
        }
    }

    // MARK: - Synchronize contacts

    func syncContacts(request: SyncRequest, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.synchronizeContacts(request: request).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }

            if let response = response {}

            completion(true)
        }
    }

    // MARK: - Logout

    func logout(completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.userLogout().request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }
}
