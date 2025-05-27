//
//  UserModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 15.01.2025.
//

import Foundation
import RealmSwift

final class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var phoneNumber: String
    @Persisted var email: String
    @Persisted var username: String
    @Persisted var passwordHash: Data // Для хранения [UInt8]
    @Persisted var role: String
    @Persisted var contacts = List<Contact>() // Связь один-ко-многим
}

struct CheckAccountResponse: Codable {
    let exists: Bool
}

struct AuthResponse: refreshTokenCodable {
    let accessToken: String
    let accessTokenDuration: Int
    var refreshToken: String?
    var refreshTokenDuration: Int?
    let tokenType: String
    let userId: String
}
