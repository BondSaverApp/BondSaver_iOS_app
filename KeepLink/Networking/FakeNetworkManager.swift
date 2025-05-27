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

    func checkAccount(phoneNumber _: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    // MARK: - Sign up

    func signup(phoneNumber _: String, password _: String, email _: String?, username _: String, completion: @escaping (String) -> Void) {
        completion("")
    }

    // MARK: - Login

    func login(phoneNumber _: String, password _: String, completion: @escaping (String) -> Void) {
        completion("")
    }

    // MARK: - Refresh token

    func refreshToken(refreshToken _: String = "", completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    // MARK: - Synchronize contacts

    func syncContacts(request _: SyncRequest, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    // MARK: - Logout

    func logout(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
