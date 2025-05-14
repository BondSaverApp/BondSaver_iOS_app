//
//  MeetingAddViewModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 11.03.2025.
//

import Combine
import RealmSwift
import SwiftUI

class MeetingAddViewModel: ObservableObject {
    @Published var selectedContacts: [Contact] = []
    @Published var topics: [Topic] = [Topic()] // Начальная тема
    @Published var isSelectingContacts = false
    @Published var contacsText = "Выбрать контакты"

    @Published var date: Date = .init()
    @Published var describtion = ""

    @ObservedResults(Contact.self) var allContacts

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $selectedContacts
            .sink(receiveValue: { [weak self] _ in
                self?.updateContactsText()
            })
            .store(in: &cancellables)
    }

    private func updateContactsText() {
        let count = selectedContacts.count
        switch count {
        case 0:
            contacsText = "Выбрать контакты"
        case 1:
            contacsText = selectedContacts.first!.firstName
        case 2:
            contacsText = selectedContacts.map {
                $0.firstName
            }[0 ... 1].joined(separator: ", ")
        default:
            contacsText = selectedContacts.map {
                $0.firstName
            }[0 ... 1].joined(separator: ", ") + " и \(selectedContacts.count - 2) других"
        }
    }

    func toggleContactSelection(_ contact: Contact) {
        if selectedContacts.contains(contact) {
            selectedContacts.removeAll { $0 == contact }
        } else {
            selectedContacts.append(contact)
        }
    }

    func saveMeeting(_ meeting: Meeting = Meeting()) {
        do {
            let realm = try Realm()

            let contactIds = selectedContacts.map { $0.id }
            let contactIdsList = RealmSwift.List<ObjectId>()
            contactIdsList.append(objectsIn: contactIds)

            let topicsList = RealmSwift.List<Topic>()
            topicsList.append(objectsIn: topics)

            try realm.write {
                meeting.date = date
                meeting.describe = describtion
                meeting.contactIds = contactIdsList
                meeting.topics = topicsList

                meeting.updateClientModifiedDate()

                realm.add(meeting)
            }
        } catch {
            print("Ошибка сохранения в Realm: \(error.localizedDescription)")
        }
    }

    func addTopic() {
        withAnimation {
            topics.append(Topic())
        }
    }

    func deleteTopic() {
        withAnimation {
            if topics.count > 1 {
                topics.removeLast()
            }
        }
    }
}
