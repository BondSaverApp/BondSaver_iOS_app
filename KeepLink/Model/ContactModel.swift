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
    @Persisted var avatarData: Data?
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
    @Persisted var clientModifiedDate: Int64 = 0
    @Persisted var serverModifiedDate: Int64?
    @Persisted var deleteDate: Int64?
}

extension Contact {
    func updateClientModifiedDate() {
        clientModifiedDate = Int64(Date().timeIntervalSince1970 * 1000)
    }

    func updateDeleteDate() {
        deleteDate = Int64(Date().timeIntervalSince1970 * 1000)
    }

    // MARK: - Convert contact to DTO

    func toDTO() -> ContactDTO {
        return ContactDTO(
            id: id.stringValue,
            updatedAtClient: clientModifiedDate,
            updatedAtServer: serverModifiedDate,
            deletedAt: deleteDate,
            photoPath: avatarData,
            firstName: firstName,
            lastName: lastName,
            middleName: middleName,
            appearance: appearance,
            meetContext: meetingContext,
            city: city,
            street: street,
            house: house,
            flat: apartment,
            notes: notes,
            site: website,
            ownerId: ownerId.stringValue,
            tags: Array(tags.map { $0.name }),
            emails: Array(emails.map { $0.email }),
            telephones: Array(phoneNumbers.map { PhoneNumberDTO(type: $0.type, number: $0.number) }),
            dates: Array(dates.map { DateEntryDTO(type: $0.type, date: $0.date) }),
            social: Array(socialNetworks.compactMap {
                guard let type = NetworkType(rawValue: $0.type) else { return nil }
                return SocialNetworkDTO(type: type, link: $0.link)
            }),
            occupations: Array(professions.map { ProfessionDTO(profession: $0.position, company: $0.workplace, jobTitle: $0.title) })
        )
    }

    func update(from dto: ContactDTO) {
        clientModifiedDate = dto.updatedAtClient
        serverModifiedDate = dto.updatedAtServer
        deleteDate = dto.deletedAt
        avatarData = dto.photoPath
        firstName = dto.firstName
        lastName = dto.lastName
        middleName = dto.middleName
        appearance = dto.appearance
        meetingContext = dto.meetContext
        city = dto.city
        street = dto.street
        house = dto.house
        apartment = dto.flat
        notes = dto.notes
        website = dto.site

        if let ownerId = try? ObjectId(string: dto.ownerId) {
            self.ownerId = ownerId
        }

        tags.append(objectsIn: dto.tags.map { tagName in
            let tag = Tag()
            tag.name = tagName
            return tag
        })

        phoneNumbers.append(objectsIn: dto.telephones.map { phoneNumberDTO in
            let phoneNumber = PhoneNumber()
            phoneNumber.number = phoneNumberDTO.number
            phoneNumber.type = phoneNumberDTO.type
            return phoneNumber
        })

        dates.append(objectsIn: dto.dates.map { dateDTO in
            let dateEntry = DateEntry()
            dateEntry.date = dateDTO.date
            dateEntry.type = dateDTO.type
            return dateEntry
        })

        socialNetworks.append(objectsIn: dto.social.map { socialDTO in
            let socialNetwork = SocialNetwork()
            socialNetwork.type = socialDTO.type.rawValue
            socialNetwork.link = socialDTO.link
            return socialNetwork
        })

        professions.append(objectsIn: dto.occupations.map { professionDTO in
            let profession = Profession()
            profession.title = professionDTO.jobTitle
            profession.workplace = professionDTO.company
            profession.position = professionDTO.profession
            return profession
        })

        emails.append(objectsIn: dto.emails.map { emailName in
            let email = Email()
            email.email = emailName
            return email
        })
    }
}

class Meeting: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var describe: String
    @Persisted var contactIds = List<ObjectId>() // ID контактов, связанных с встречей
    @Persisted var topics = List<Topic>()
    @Persisted var clientModifiedDate: Int64 = 0
    @Persisted var serverModifiedDate: Int64?
    @Persisted var deleteDate: Int64?
}

extension Meeting {
    func updateClientModifiedDate() {
        clientModifiedDate = Int64(Date().timeIntervalSince1970 * 1000)
    }

    func updateDeleteDate() {
        deleteDate = Int64(Date().timeIntervalSince1970 * 1000)
    }
}

class Topic: Object, ObjectKeyIdentifiable {
    init(title: String, describe: String) {
        self.title = title
        self.describe = describe
    }

    override init() {
        super.init()
    }

    @Persisted var title: String
    @Persisted var describe: String
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

struct ContactDTO: Codable {
    var id: String
    var updatedAtClient: Int64 = 0
    var updatedAtServer: Int64?
    var deletedAt: Int64?
    var photoPath: Data?
    var firstName: String
    var lastName: String
    var middleName: String
    var appearance: String
    var meetContext: String
    var city: String
    var street: String
    var house: String
    var flat: String
    var notes: String
    var site: String
    var ownerId: String
    var tags: [String]
    var emails: [String]
    var telephones: [PhoneNumberDTO]
    var dates: [DateEntryDTO]
    var social: [SocialNetworkDTO]
    var occupations: [ProfessionDTO]
}

struct PhoneNumberDTO: Codable {
    var type: String
    var number: String
}

struct DateEntryDTO: Codable {
    var type: String
    var date: Date
}

struct SocialNetworkDTO: Codable {
    var type: NetworkType
    var link: String
}

enum NetworkType: String, Codable {
    case telegram = "Telegram"
    case vk = "VK"
}

struct ProfessionDTO: Codable {
    var profession: String
    var company: String
    var jobTitle: String
}

struct ContactUpdateFromServer: Codable {
    var id: String
    var updatedAtClient: Int64
    var updatedAtServer: Int64?
}

struct MeetingUpdateFromClient: Codable {
    var id: String
    var updatedAtClient: Int64
    var updatedAtServer: Int64?
    var deletedAt: Int64?
    var date: Int64
    var description: String
    var topics: [TopicDTO]
    var contactId: String
    var ownerId: String
}

struct MeetingUpdateFromServer: Codable {
    var id: String
    var updatedAtClient: Int64
    var updatedAtServer: Int64?
}

struct TopicDTO: Codable {
    var name: String
    var description: String
    var answer: String
    var contactId: String
}

struct SyncRequest: Codable {
    let contactUpdatesFromClient: [ContactDTO]
    let contactUpdatesFromServer: [ContactUpdateFromServer]
    let meetingUpdatesFromClient: [MeetingUpdateFromClient]
    let meetingUpdatesFromServer: [MeetingUpdateFromServer]
}

struct SyncResponse: Codable {
    let contactsToUpdate: [ContactDTO]
    let contactsUpdated: [ContactUpdateFromServer]
    let meetingsToUpdate: [MeetingUpdateFromClient]
    let meetingsUpdated: [MeetingUpdateFromServer]
}
