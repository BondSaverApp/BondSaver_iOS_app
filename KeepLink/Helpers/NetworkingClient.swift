//
//  NetworkingClient.swift
//  KeepLink
//
//  Created by Андрей Степанов on 23.02.2025.
//

import Foundation
import OpenAPIURLSession
import KeychainSwift

// MARK: - NetworkingClient

public struct NetworkingClient {
    static let shared = NetworkingClient()

    private let client: Client
    private let baseURL: URL // Замените на ваш базовый URL

    public init() {
        self.baseURL = try! Servers.Server1.url()

        self.client = Client(
            serverURL: baseURL,
            transport: URLSessionTransport()
        )
    }

    // MARK: - Check Account

    public func checkAccount(phoneNumber: String) async throws -> CheckAccountResponseWrapper {
        let url = baseURL.appendingPathComponent("/auth/check-account")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = ["phoneNumber": phoneNumber]
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        // Декодируем JSON
        let decoder = JSONDecoder()
        let responseBody = try decoder.decode(CheckAccountResponseWrapper.self, from: data)
        return responseBody
    }
    
    // MARK: - Signup

    public func signup(phoneNumber: String, password: String, email: String?, username: String) async throws -> AuthResponseWrapper {
        let url = baseURL.appendingPathComponent("/auth/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any?] = [
            "phoneNumber": phoneNumber,
            "password": password,
            "email": email,
            "username": username
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody.compactMapValues { $0 }, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let responseBody = try JSONDecoder().decode(AuthResponseWrapper.self, from: data)
        
        let keychain = KeychainSwift()
        keychain.set(responseBody.accessToken, forKey: "accessToken")
        keychain.set(responseBody.userId, forKey: "userId")
        
        return responseBody
    }

    // MARK: - Login

    public func login(phoneNumber: String, password: String) async throws -> AuthResponseWrapper {
        let url = baseURL.appendingPathComponent("/auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = ["phoneNumber": phoneNumber, "password": password]
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let responseBody = try JSONDecoder().decode(AuthResponseWrapper.self, from: data)
        
        let keychain = KeychainSwift()
        keychain.set(responseBody.accessToken, forKey: "accessToken")
        keychain.set(responseBody.userId, forKey: "userId")
        
        return responseBody
    }

    // MARK: - Refresh Token

    public func refreshToken(refreshToken: String = "") async throws -> AuthResponseWrapper {
        let url = baseURL.appendingPathComponent("/auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if refreshToken == "" {
            let keychain = KeychainSwift()
            var refreshToken = keychain.get("accessToken") ?? ""
        }
        
        request.addCookies(["refreshToken": refreshToken])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let responseBody = try JSONDecoder().decode(AuthResponseWrapper.self, from: data)
        return responseBody
    }

    // MARK: - Logout

    public func logout() async throws {
        let url = baseURL.appendingPathComponent("/auth/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw NetworkingError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
    }

    // MARK: - Networking Error

    public enum NetworkingError: Error {
        case unexpectedStatusCode(Int)
        case invalidResponse
        case badRequest
        case serverError
    }
}


// MARK: - Обертки для internal типов

public struct CheckAccountResponseWrapper: Codable {
    public let exists: Bool
}

public struct AuthResponseWrapper: Codable {
    public let accessToken: String
    public let accessTokenDuration: Double
    public let tokenType: String
    public let userId: String

    public init(accessToken: String, accessTokenDuration: Double, tokenType: String, userId: String) {
        self.accessToken = accessToken
        self.accessTokenDuration = accessTokenDuration
        self.tokenType = tokenType
        self.userId = userId
    }
}

// MARK: - Расширение для добавления Cookie

extension URLRequest {
    mutating func addCookies(_ cookies: [String: String]) {
        let cookieHeader = cookies.map { "\($0.key)=\($0.value)" }.joined(separator: "; ")
        self.setValue(cookieHeader, forHTTPHeaderField: "Cookie")
    }
}
