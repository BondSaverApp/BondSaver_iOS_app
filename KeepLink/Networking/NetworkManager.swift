//
//  NetworkManager.swift
//  KeepLink
//
//  Created by Maria Mayorova on 18.04.2025.
//

import Foundation
import KeychainSwift

struct NetworkManager: NetworkManagerProtocol {
    private let service: APIService
    let logging: Logging

    init(service: APIService, logging: @escaping Logging) {
        self.service = service
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

        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }

            let keychain = KeychainSwift()
            keychain.set(response?.accessToken ?? "", forKey: "accessToken")
            keychain.set(response?.userId ?? "", forKey: "userId")

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

        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }

            let keychain = KeychainSwift()
            keychain.set(response?.accessToken ?? "", forKey: "accessToken")
            keychain.set(response?.userId ?? "", forKey: "userId")

            completion(response?.accessToken ?? "")
        }
    }

    // MARK: - Refresh token

    func refreshToken(refreshToken: String = "", completion: @escaping (Bool) -> Void) {
        guard var request = Endpoint.refreshToken(refreshToken: refreshToken).request else {
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

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
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
