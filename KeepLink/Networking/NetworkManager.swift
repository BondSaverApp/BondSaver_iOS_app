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
    
    func checkAccount(email: String, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.checkAccount(email: email).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }
        
        service.makeRequest(with: request, respModel: CheckAccountResponse.self, logging: logging) { response, _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            print(response?.exists)
            completion(response?.exists ?? false)
        }
    }
    
    // MARK: - Sign up
    
    func signup(email: String, password: String, username: String, completion: @escaping (String) -> Void) {
        
        guard let request = Endpoint.userSignup(
            email: email,
            password: password,
            username: username
        ).request else {
            logging("Error: Failed to create request")
            completion("")
            return
        }
        
        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { response, httpResponse, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }
            
            print("happy")
            
            var refreshToken: String? = nil
            var refreshTokenDuration: TimeInterval? = nil
            var accessTokenDuration : TimeInterval? = nil
            let cookieNameRefresh = "refreshToken="
            let delimiter = ";"
            let cookieNameMaxAge = " Max-Age="
            
            guard let durationInt = response?.accessTokenDuration else { return }
            accessTokenDuration = TimeInterval(durationInt)
            
            var cookies: String? = httpResponse?.value(forHTTPHeaderField: "Set-Cookie") ?? nil
            if let cookiesString = cookies {
                let refreshTokenField = cookiesString.split(separator: delimiter).first (where: { $0.hasPrefix(cookieNameRefresh)})
                
                let maxAgeField = cookiesString.split(separator: delimiter).first (where: { $0.hasPrefix(cookieNameMaxAge)})
                
                guard let refreshTokenField,
                      let equalIndexRefresh = refreshTokenField.firstIndex(of: "=") else { return }
                
                guard let maxAgeField,
                      let equalIndexMaxAge = maxAgeField.firstIndex(of: "=") else { return }
                  
                refreshToken = String(refreshTokenField.suffix(from: refreshTokenField.index(after: equalIndexRefresh)))
                let maxAge = String(maxAgeField.suffix(from: maxAgeField.index(after: equalIndexMaxAge)))
                refreshTokenDuration = TimeInterval(maxAge) ?? 0
            }
            
            tokenManager.saveTokens(accessToken: response?.accessToken ?? "",
                                    refreshToken: refreshToken ?? "",
                                    accessTokenExpiry: Date().addingTimeInterval(accessTokenDuration ?? 0),
                                    refreshTokenExpiry: Date().addingTimeInterval(refreshTokenDuration ?? 0))
            
            completion(response?.accessToken ?? "")
        }
    }
    
    // MARK: - Login
    
    func login(email: String, password: String, completion: @escaping (String) -> Void) {
        guard let request = Endpoint.userLogin(email: email, password: password).request else {
            logging("Error: Failed to create request")
            completion("")
            return
        }
        
        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { response, httpResponse, error in
            if let error = error {
                logging(error.localizedDescription)
                completion("")
                return
            }
            
            var refreshToken: String? = nil
            var refreshTokenDuration: TimeInterval? = nil
            var accessTokenDuration : TimeInterval? = nil
            let cookieNameRefresh = "refreshToken="
            let delimiter = ";"
            let cookieNameMaxAge = " Max-Age="
            
            guard let durationInt = response?.accessTokenDuration else { return }
            accessTokenDuration = TimeInterval(durationInt)
            
            var cookies: String? = httpResponse?.value(forHTTPHeaderField: "Set-Cookie") ?? nil
            if let cookiesString = cookies {
                let refreshTokenField = cookiesString.split(separator: delimiter).first (where: { $0.hasPrefix(cookieNameRefresh)})
                
                let maxAgeField = cookiesString.split(separator: delimiter).first (where: { $0.hasPrefix(cookieNameMaxAge)})
                
                guard let refreshTokenField,
                      let equalIndexRefresh = refreshTokenField.firstIndex(of: "=") else { return }
                
                guard let maxAgeField,
                      let equalIndexMaxAge = maxAgeField.firstIndex(of: "=") else { return }
                  
                refreshToken = String(refreshTokenField.suffix(from: refreshTokenField.index(after: equalIndexRefresh)))
                let maxAge = String(maxAgeField.suffix(from: maxAgeField.index(after: equalIndexMaxAge)))
                refreshTokenDuration = TimeInterval(maxAge) ?? 0
            }
            
            tokenManager.saveTokens(accessToken: response?.accessToken ?? "",
                                    refreshToken: refreshToken ?? "",
                                    accessTokenExpiry: Date().addingTimeInterval(accessTokenDuration ?? 0),
                                    refreshTokenExpiry: Date().addingTimeInterval(refreshTokenDuration ?? 0))
            
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
        
        service.makeRequest(with: request, respModel: AuthResponse.self, logging: logging) { _, _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }

            if refreshToken == "" {
                let keychain = KeychainSwift()
                var refreshToken = keychain.get("accessToken") ?? ""
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
        
        service.makeRequest(with: request, respModel: SyncResponse.self, logging: logging) { response, _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            
            if let response = response {
                
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
        
        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }
}
