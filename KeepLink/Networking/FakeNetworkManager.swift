//
//  FakeNetworkManager.swift
//  KeepLink
//
//  Created by Андрей Степанов on 16.05.2025.
//

import Foundation
import KeychainSwift

struct FakeNetworkManager: NetworkManagerProtocol {
    let logging: Logging

    init(logging: @escaping Logging) {
        self.logging = logging
    }

    // MARK: - Check account existence

    func checkAccount(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        completion(false)
    }

    // MARK: - Sign up

    func signup(phoneNumber: String, password: String, email: String?, username: String, completion: @escaping (String) -> Void) {
        completion("")
    }

    // MARK: - Login

    func login(phoneNumber: String, password: String, completion: @escaping (String) -> Void) {
        completion("")
    }

    // MARK: - Refresh token

    func refreshToken(refreshToken: String = "", completion: @escaping (Bool) -> Void) {
            completion(true)
    }

    // MARK: - Synchronize contacts

    func syncContacts(request: SyncRequest, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    // MARK: - Logout

    func logout(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
