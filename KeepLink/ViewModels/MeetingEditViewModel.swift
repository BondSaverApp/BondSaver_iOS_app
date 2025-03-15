//
//  MeetingEditViewModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 12.03.2025.
//

import SwiftUI
import RealmSwift
import Combine

final class MeetingEditViewModel: ObservableObject {
    @Published var selectedContacts: [Contact] = []
    @Published var topics: [EditTopic] = [EditTopic()]
    @Published var isSelectingContacts = false
    @Published var contacsText: String = ""
    
    @Published var date: Date = Date()
    @Published var describtion = ""
    @Published var isAlertPresented = false
    
    @ObservedResults(Contact.self) var allContacts
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $selectedContacts
            .sink(receiveValue: { [weak self] _ in
                self?.updateContactsText()
            })
            .store(in: &cancellables)
    }
    
    func loadData(from meeting: Meeting) {
        var contacts: [Contact] = []
        for id in meeting.contactIds {
            contacts.append(DataBase.shared.contacts.first { $0.id == id } ?? Contact())
        }
        
        selectedContacts = contacts
        for topic in meeting.topics {
            let editTopic = EditTopic(title: topic.title, description: topic.describe)
            topics.append(editTopic)
        }
        date = meeting.date
        describtion = meeting.describe
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
            }[0...1].joined(separator: ", ")
        default:
            contacsText = selectedContacts.map {
                $0.firstName
            }[0...1].joined(separator: ", ") + " и \(selectedContacts.count - 2) других"
        }
    }

    func toggleContactSelection(_ contact: Contact) {
        if selectedContacts.contains(contact) {
            selectedContacts.removeAll { $0 == contact }
        } else {
            selectedContacts.append(contact)
        }
    }
    
    func saveMeeting(_ meeting: Meeting) {
        guard let thawedMeeting = meeting.thaw() else {
            print("Ошибка: Не удалось разморозить объект.")
            return
        }
        
        do {
            let realm = try Realm()
            
            let contactIds = selectedContacts.map { $0.id }
            let contactIdsList = RealmSwift.List<ObjectId>()
            contactIdsList.append(objectsIn: contactIds)
            
            let topicsList = RealmSwift.List<Topic>()
            for topic in topics {
                let newTopic = Topic()
                newTopic.describe = topic.description
                newTopic.title = topic.title
                topicsList.append(newTopic)
            }
            
            try realm.write {
                thawedMeeting.date = date
                thawedMeeting.describe = describtion
                thawedMeeting.contactIds = contactIdsList
                thawedMeeting.topics = RealmSwift.List<Topic>()//topicsList
            }
        } catch {
            print("Ошибка сохранения в Realm: \(error.localizedDescription)")
        }
    }

    func addTopic() {
        withAnimation {
            topics.append(EditTopic())
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


struct EditTopic: Identifiable {
    let id = UUID()
    var title: String = ""
    var description: String = ""
}
