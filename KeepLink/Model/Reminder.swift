//
//  Reminder.swift
//  KeepLink
//
//  Created by Андрей Степанов on 02.05.2025.
//

import Foundation
import RealmSwift

final class Reminder: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var date: Date
    @Persisted var relatedContactIds = List<ObjectId>()
}
