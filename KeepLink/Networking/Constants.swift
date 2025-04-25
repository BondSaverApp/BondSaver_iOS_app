//
//  Constants.swift
//  KeepLink
//
//  Created by Maria Mayorova on 18.04.2025.
//

import Foundation

enum Constants {
    // MARK: - API
    
    static let scheme = "http"
    static let baseURL = "localhost"
    static let port: Int? = 8080
    
    static let apiPath = "/api"
    
    static let authPath = "/auth"
    static let checkAccount = "/check-account"
    static let signUpPath = "/signup"
    static let loginPath = "/login"
    static let refreshPath = "/refresh"
    static let logoutPath = "/logout"
    
    static let contactsPath = "/contact"
    static let synchronizePath = "/synchronize"
    
}
