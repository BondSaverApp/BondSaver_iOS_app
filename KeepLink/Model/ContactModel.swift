//
//  ContactModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 15.01.2025.
//

import Foundation
import RealmSwift

final class Contact: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var avatar: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var middleName: String
    @Persisted var appearance: String
    @Persisted var meetingContext: String
    @Persisted var city: String
    @Persisted var street: String
    @Persisted var house: String
    @Persisted var apartment: String
    @Persisted var notes: String
    @Persisted var website: String
    @Persisted var ownerId: ObjectId // Владелец контакта (User)
    @Persisted var meetingPlace: MeetingPlace?
    @Persisted var tags = List<Tag>()
    @Persisted var phoneNumbers = List<PhoneNumber>()
    @Persisted var dates = List<DateEntry>()
    @Persisted var socialNetworks = List<SocialNetwork>()
    @Persisted var professions = List<Profession>()
    @Persisted var emails = List<Email>()
}

class Meeting: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var describe: String
    @Persisted var contactIds = List<ObjectId>() // ID контактов, связанных с встречей
}

class Topic: Object {
    @Persisted var title: String
    @Persisted var describe: String
    @Persisted var meetings = List<Meeting>() // Встречи, связанные с темой
}

class MeetingPlace: Object {
    @Persisted var name: String
}

class Tag: Object {
    @Persisted var name: String
}

class PhoneNumber: Object {
    @Persisted var type: String
    @Persisted var number: String
}

class DateEntry: Object {
    @Persisted var type: String
    @Persisted var date: Date
}

class SocialNetwork: Object {
    @Persisted var link: String
    @Persisted var type: String
}

class Profession: Object {
    @Persisted var title: String
    @Persisted var workplace: String
    @Persisted var position: String
}

class Email: Object {
    @Persisted var email: String
}
