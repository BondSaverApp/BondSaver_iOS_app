//
//  Endpoint.swift
//  KeepLink
//
//  Created by Maria Mayorova on 18.04.2025.
//

import Foundation

enum Endpoint {
    case checkAccount(url: String = Constants.apiPath, url1: String = Constants.authPath, url2: String = Constants.checkAccount, phoneNumber: String)
    case userSignup(url: String = Constants.apiPath, url1: String = Constants.authPath, url2: String = Constants.signUpPath, phoneNumber: String, password: String, email: String?, username: String)
    case userLogin(url: String = Constants.apiPath, url1: String = Constants.authPath, url2: String = Constants.loginPath, phoneNumber: String, password: String)
    case refreshToken(url: String = Constants.apiPath, url1: String = Constants.authPath, url2: String = Constants.refreshPath, refreshToken: String = "")
    case userLogout(url: String = Constants.apiPath, url1: String = Constants.authPath, url2: String = Constants.logoutPath)
    case synchronizeContacts(url: String = Constants.apiPath, url1: String = Constants.contactsPath, url2: String = Constants.synchronizePath, request: SyncRequest)

    var request: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValues(for: self)
        return request
    }

    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    private var path: String {
        switch self {
        case let .checkAccount(url, url1, url2, _),
             let .userSignup(url, url1, url2, _, _, _, _),
             let .userLogin(url, url1, url2, _, _),
             let .refreshToken(url, url1, url2, _),
             let .userLogout(url, url1, url2),
             let .synchronizeContacts(url, url1, url2, _):
            return url + url1 + url2
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        default: return []
        }
    }

    private var httpMethod: String {
        switch self {
        case .checkAccount,
             .userSignup,
             .userLogin,
             .refreshToken,
             .userLogout,
             .synchronizeContacts:
            return HTTP.Method.post.rawValue
        }
    }

    private var httpBody: Data? {
        switch self {
        case let .checkAccount(_, _, _, phoneNumber):
            let requestBody = try? JSONEncoder().encode(["phoneNumber": phoneNumber])
            return requestBody

        case let .userSignup(_, _, _, phoneNumber, password, email, username):
            let requestBody: [String: Any?] = [
                "phoneNumber": phoneNumber,
                "password": password,
                "email": email,
                "username": username,
            ]
            return try? JSONSerialization.data(withJSONObject: requestBody.compactMapValues { $0 }, options: [])

        case let .userLogin(_, _, _, phoneNumber, password):
            let requestBody = try? JSONEncoder().encode(["phoneNumber": phoneNumber, "password": password])
            return requestBody

        case let .synchronizeContacts(_, _, _, request):
            return try? JSONEncoder().encode(request)

        default: return nil
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case let .refreshToken(refreshToken):
            setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
            setValue("application/json", forHTTPHeaderField: "Content-Type")
            setValue("application/json", forHTTPHeaderField: "Accept")
        default:
            setValue("application/json", forHTTPHeaderField: "Content-Type")
            setValue("application/json", forHTTPHeaderField: "Accept")
        }
    }

    mutating func addCookies(_ cookies: [String: String]) {
        let cookieHeader = cookies.map { "\($0.key)=\($0.value)" }.joined(separator: "; ")
        setValue(cookieHeader, forHTTPHeaderField: "Cookie")
    }
}

extension URLSession {
    func dataTaskWithCookies(
        for request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?, String?, Int?) -> Void
    ) {
        let task = dataTask(with: request) { data, response, error in
            var refreshToken: String?
            var maxAge: Int?

            if let httpResponse = response as? HTTPURLResponse,
               let headerFields = httpResponse.allHeaderFields as? [String: String],
               let setCookieHeader = headerFields["Set-Cookie"]
            {
                let parts = setCookieHeader.components(separatedBy: ";")
                for part in parts {
                    let trimmed = part.trimmingCharacters(in: .whitespaces)
                    if trimmed.starts(with: "refreshToken=") {
                        refreshToken = trimmed.replacingOccurrences(of: "refreshToken=", with: "")
                    } else if trimmed.starts(with: "Max-Age=") {
                        maxAge = Int(trimmed.replacingOccurrences(of: "Max-Age=", with: ""))
                    }
                }
            }

            completion(data, response, error, refreshToken, maxAge)
        }

        task.resume()
    }
}
