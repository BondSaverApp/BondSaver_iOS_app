//
//  AuthServiceProtocol.swift
//  KeepLink
//
//  Created by Maria Mayorova on 07.05.2025.
//

import Foundation

protocol AuthServiceProtocol: ObservableObject {
    var isAuthentificated: Bool { get }
    func checkAuthStatus(completion: @escaping (Bool) -> Void)
}
