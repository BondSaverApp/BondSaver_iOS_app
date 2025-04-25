//
//  NetworkManagerProtocol.swift
//  KeepLink
//
//  Created by Maria Mayorova on 19.04.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    var logging: Logging { get }
    
    func checkAccount(phoneNumber: String, completion: @escaping (Bool) -> Void)
    func signup(phoneNumber: String, password: String, email: String?, username: String, completion: @escaping (String) -> Void)
    func login(phoneNumber: String, password: String, completion: @escaping (String) -> Void)
    func refreshToken(refreshToken: String, completion: @escaping (Bool) -> Void)
    func syncContacts(request: SyncRequest, completion: @escaping (Bool) -> Void)
    func logout(completion: @escaping (Bool) -> Void)
}
