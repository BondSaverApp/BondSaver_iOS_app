//
//  ContactMainViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import SwiftUI

final class ContactMainViewModel: ObservableObject {
    @Published var isEditViewPresented: Bool = false

    @Published var dateOfBirthPicker: Date = .now
    @Published var contextTextField: String = ""
    @Published var aimTextField: String = ""
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
    @Published var dateOfBirth: Date?

    @Published var selectedTags: [String] = []
    @Published var isShowingContextsOfMeeting = false
    @Published var isShowingMore = false

    @Published var nameTextField: String = ""
    @Published var surnameTextField: String = ""
    @Published var patronymicTextField: String = ""

    @Published var selectedImageData: Data? = nil

    func loadData(from contact: Contact) {
        nameTextField = contact.firstName
        surnameTextField = contact.lastName
        patronymicTextField = contact.middleName
        appearanceTextField = contact.appearance
        noteTextField = contact.notes
        selectedImageData = contact.avatarData
        selectedTags = contact.tags.map { tag in
            tag.name
        }
        contextTextField = contact.meetingPlace?.name ?? ""
        phoneTextField = contact.phoneNumbers.first?.number ?? ""
        cityTextField = contact.city
        streetTextField = contact.street
        houseTextField = contact.house
        flatTextField = contact.apartment
        websiteTextField = contact.website
        networkTextField = contact.socialNetworks.first?.link ?? ""
        professionTextField = contact.professions.first?.title ?? ""
        emailTextField = contact.emails.first?.email ?? ""
        dateOfBirth = contact.dates.first?.date ?? nil
    }
}
