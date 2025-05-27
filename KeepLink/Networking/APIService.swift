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
    func makeRequest<T: Codable>(with request: URLRequest, respModel: T.Type, logging: @escaping Logging, completion: @escaping (T?, HTTPURLResponse?, APIError?) -> Void)
}

class APIService: Service {
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func makeRequest<T: Codable>(
        with request: URLRequest,
        respModel: T.Type,
        logging: @escaping Logging,
        completion: @escaping (T?, HTTPURLResponse?, APIError?) -> Void
    ) {
        
        urlSession.dataTask(with: request) { data, resp, error in
            if let error = error {
                completion(nil, nil, .urlSessionError(error.localizedDescription))
                return
            }
            
            guard let httpResponse = resp as? HTTPURLResponse else {
                completion(nil, nil, .invalidResponse())
                return
            }
            
            if 500..<600 ~= httpResponse.statusCode {
                completion(nil, httpResponse, .serverError())
                return
            }
            
            guard let data = data else {
                completion(nil,  httpResponse, .invalidResponse())
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
                    completion(nil, httpResponse, .serverError(detail))
                    return
                }
                
                if T.self == Data.self {
                    print(data)
                    print("printed")
                    completion(data as? T, httpResponse, nil)
                    return
                }
                
                let result = try JSONDecoder().decode(T.self, from: data)
                print("Result: ", result)
                completion(result, httpResponse, nil)
            } catch {
                completion(nil, httpResponse, .decodingError())
            }
            
        }.resume()
    }
}
