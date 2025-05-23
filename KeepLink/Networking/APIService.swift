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

            do {
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let detail = errorResponse["detail"]
                {
                    completion(nil, .serverError(detail))
                    return
                }

                if T.self == Data.self {
                    completion(data as? T, nil)
                    return
                }

                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, .decodingError())
            }

        }.resume()
    }
}
