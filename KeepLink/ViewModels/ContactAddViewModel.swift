//
//  ContactAddViewModel.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import SwiftUI

final class ContactAddViewModel: ObservableObject {
    @Published var nameTextField: String = ""
    @Published var surnameTextField: String = ""
    @Published var patronymicTextField: String = ""
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
    @Published var dateOfBirth = Date()
    @Published var avatarUrl: String = ""
    
    @Published var selectedTags: [String] = []
    @Published var isShowingContextsOfMeeting = false
    @Published var isShowingTags = false
    @Published var isShowingMore = false
    
}
