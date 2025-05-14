//
//  ContactAddViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import RealmSwift
import SwiftUI

final class ContactAddViewModel: ObservableObject {
    @Published var nameTextField: String = ""
    @Published var surnameTextField: String = ""
    @Published var patronymicTextField: String = ""
    @Published var contextTextField: String = ""
    @Published var noteTextField: String = ""
    @Published var phoneTextField: String = ""
    @Published var appearanceTextField: String = ""
    @Published var cityTextField: String = ""
    @Published var streetTextField: String = ""
    @Published var houseTextField: String = ""
    @Published var flatTextField: String = ""
    @Published var websiteTextField: String = ""
    @Published var networkTextField: String = ""
    @Published var professionTextField: String = ""
    @Published var emailTextField: String = ""
    @Published var dateOfBirth = Date()

    @Published var selectedImageData: Data? = nil

    @Published var selectedTags: [String] = []
    @Published var isShowingContextsOfMeeting = false
    @Published var isShowingTags = false

    @Published var isAlertPresented = false // алерт для удаления
    @Published var showPhotosPicker = false
    @Published var showImageCropper = false

    func saveContact(_ contact: Contact = Contact()) {
        do {
            let realm = try Realm()

            let tags = selectedTags.map { tagString -> Tag in
                let tag = Tag()
                tag.name = tagString
                return tag
            }

            let tagsList = RealmSwift.List<Tag>()
            tagsList.append(objectsIn: tags)

            let meetingPlace = MeetingPlace()
            meetingPlace.name = contextTextField

            let phoneNumbers = RealmSwift.List<PhoneNumber>()
            let number = PhoneNumber()
            number.number = phoneTextField
            number.type = "Основной"
            phoneNumbers.append(number)

            let socialNetworks = RealmSwift.List<SocialNetwork>()
            let socialNetwork = SocialNetwork()
            socialNetwork.link = networkTextField
            socialNetwork.type = "Основная"
            socialNetworks.append(socialNetwork)

            let professions = RealmSwift.List<Profession>()
            let profession = Profession()
            profession.title = networkTextField
            profession.workplace = "Основная"
            profession.position = "джун"
            professions.append(profession)

            let emails = RealmSwift.List<Email>()
            let email = Email()
            email.email = emailTextField
            emails.append(email)

            let dates = RealmSwift.List<DateEntry>()
            let date = DateEntry()
            date.date = dateOfBirth
            date.type = "Основная"
            dates.append(date)

            try realm.write {
                contact.firstName = nameTextField
                contact.lastName = surnameTextField
                contact.middleName = patronymicTextField
                contact.meetingContext = contextTextField
                contact.appearance = appearanceTextField
                contact.avatarData = selectedImageData
                contact.notes = noteTextField
                contact.tags = tagsList
                contact.meetingPlace = meetingPlace
                contact.phoneNumbers = phoneNumbers
                contact.appearance = appearanceTextField
                contact.city = cityTextField
                contact.street = streetTextField
                contact.house = houseTextField
                contact.apartment = flatTextField
                contact.website = websiteTextField
                contact.socialNetworks = socialNetworks
                contact.professions = professions
                contact.emails = emails
                contact.dates = dates

                contact.updateClientModifiedDate() // Обновляем время изменения

                realm.add(contact)
            }
        } catch {
            print("Ошибка сохранения в Realm: \(error.localizedDescription)")
        }
    }
}
