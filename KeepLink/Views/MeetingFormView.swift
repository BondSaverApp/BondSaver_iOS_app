//
//  MeetingFormView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 11.03.2025.
//

import RealmSwift
import SwiftUI

struct MeetingFormView: View {
    @ObservedResults(Contact.self) var contacts
    @State var selectedContacts: Set<Contact> = []

    @State var isContactsExpanded: Bool = false

    var body: some View {
        Group {
//            contactsSection
//
//            timeSelectionSection
//
//            themesSection
        }
    }
//
//    @ViewBuilder
//    var contactsSection: some View {
//        if !isContactsExpanded {
//            var contactsList = ""
//            if !selectedContacts.isEmpty {
//                let count = selectedContacts.count
//                if count >= 1 {
//                    contactsList += selectedContacts.first!.firstName
//                }
//                if count >= 2 {
//                    contactsList += ", " + selectedContacts.first!.firstName
//                }
//                if count >= 3 {
//                    contactsList += " и ещё \(count - 2)"
//                }
//            } else {
//                contactsList = "Нет участников"
//            }
//            return Section {
//
//            }
//        } else {
//
//        }
//    }
//
//    var timeSelectionSection: some View {
//
//    }
//
//    var themesSection: some View {
//
//    }
}

#Preview {
    MeetingFormView()
}
