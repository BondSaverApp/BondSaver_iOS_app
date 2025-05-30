//
//  APIService.swift
//  KeepLink
//
//  Created by Maria Mayorova on 19.04.2025.
//

import Foundation

enum APIError: Error {
    case urlSessionError(String)
    case serverError(String = "Server error")
    case invalidResponse(String = "Invalid response from server.")
    case decodingError(String = "Error parsing server response.")
}

protocol Service {
    func makeRequest<T: Codable>(with request: URLRequest, respModel: T.Type, logging: @escaping Logging, completion: @escaping (T?, APIError?) -> Void)
}

class APIService: Service {
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func makeRequestWithCookies<T: refreshTokenCodable>(
        with request: URLRequest,
        respModel _: T.Type,
        logging _: @escaping Logging,
        completion: @escaping (T?, APIError?) -> Void
    ) {
        urlSession.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(nil, .urlSessionError(error.localizedDescription))
                return
            }

            if let resp = resp as? HTTPURLResponse, 500 ..< 600 ~= resp.statusCode {
                completion(nil, .serverError())
                return
            }

            var token: String?
            var maxAge: String?

            if let response = resp as? HTTPURLResponse,
               let headerFields = response.allHeaderFields as? [String: String],
               let url = response.url
            {
                if let setCookieHeader = headerFields["Set-Cookie"] {
                    let parts = setCookieHeader.components(separatedBy: ";")

                    for part in parts {
                        let trimmed = part.trimmingCharacters(in: .whitespaces)
                        if trimmed.starts(with: "refreshToken=") {
                            token = trimmed.replacingOccurrences(of: "refreshToken=", with: "")
                        } else if trimmed.starts(with: "Max-Age=") {
                            maxAge = trimmed.replacingOccurrences(of: "Max-Age=", with: "")
                        }
                    }

                    print("Token: \(token ?? "nil")")
                    print("Max-Age: \(maxAge ?? "nil")")
                }
            }

            guard let data = data else {
                completion(nil, .invalidResponse())
                return
            }
            print("📥 Server response raw JSON:")

            if let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            } else {
                print("Не удалось декодировть")
            }

            do {
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let detail = errorResponse["detail"]
                {
                    completion(nil, .serverError(detail))
                    return
                }

                if T.self == Data.self {
                    var response = data as? T
                    response?.refreshToken = token
                    response?.refreshTokenDuration = Int(maxAge ?? "0")

                    completion(response, nil)
                    return
                }

                var result = try JSONDecoder().decode(T.self, from: data)
                print("Result: ", result)

                result.refreshToken = token
                result.refreshTokenDuration = Int(maxAge ?? "0")

                completion(result, nil)
            } catch {
                completion(nil, .decodingError())
            }

        }.resume()
    }

    func makeRequest<T: Codable>(
        with request: URLRequest,
        respModel _: T.Type,
        logging _: @escaping Logging,
        completion: @escaping (T?, APIError?) -> Void
    ) {
        urlSession.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(nil, .urlSessionError(error.localizedDescription))
                return
            }

            if let resp = resp as? HTTPURLResponse, 500 ..< 600 ~= resp.statusCode {
                completion(nil, .serverError())
                return
            }

            guard let data = data else {
                completion(nil, .invalidResponse())
                return
            }
            print("📥 Server response raw JSON:")

            if let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            } else {
                print("Не удалось декодировть")
            }

            do {
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let detail = errorResponse["detail"]
                {
                    completion(nil, .serverError(detail))
                    return
                }

                if T.self == Data.self {
                    print(data)
                    print("printed")
                    completion(data as? T, nil)
                    return
                }

                let result = try JSONDecoder().decode(T.self, from: data)
                print("Result: ", result)
                completion(result, nil)
            } catch {
                completion(nil, .decodingError())
            }

        }.resume()
    }
}

protocol refreshTokenCodable: Codable {
    var refreshToken: String? { get set }
    var refreshTokenDuration: Int? { get set }
}
