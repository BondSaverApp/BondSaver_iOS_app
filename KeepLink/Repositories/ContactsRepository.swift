//
//  ContactsRepository.swift
//  KeepLink
//
//  Created by Maria Mayorova on 16.03.2025.
//

import Foundation
import RealmSwift
import SwiftUI

final class ContactsRepository {
    @ObservedResults(Contact.self) var contacts
    let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func syncContacts() async {
        var contactUpdatesFromClient: [ContactDTO] = []
        var contactUpdatesFromServer: [ContactUpdateFromServer] = []

        for contact in contacts {
            if let deleteDate = contact.deleteDate {
                contactUpdatesFromServer.append(
                    ContactUpdateFromServer(
                        id: contact.id.stringValue,
                        updatedAtClient: deleteDate,
                        updatedAtServer: contact.serverModifiedDate
                    ))
            } else if contact.clientModifiedDate > (contact.serverModifiedDate ?? 0) {
                contactUpdatesFromClient.append(contact.toDTO())
            } else {
                contactUpdatesFromServer.append(
                    ContactUpdateFromServer(
                        id: contact.id.stringValue,
                        updatedAtClient: contact.clientModifiedDate,
                        updatedAtServer: contact.serverModifiedDate
                    ))
            }
        }

        let syncRequest = SyncRequest(
            contactUpdatesFromClient: contactUpdatesFromClient,
            contactUpdatesFromServer: contactUpdatesFromServer,
            meetingUpdatesFromClient: [],
            meetingUpdatesFromServer: []
        )

        networkManager.syncContacts(request: syncRequest) { _ in }
        do {
            try await updateServerModifiedDate(for: syncRequest.contactUpdatesFromClient)
        } catch {
            print("Ошибка синхронизации: \(error.localizedDescription)")
        }
    }

    private func updateServerModifiedDate(for sentContacts: [ContactDTO]) async throws {
        let realm = try await Realm()
        try realm.write {
            for contactDTO in sentContacts {
                if let contact = contacts.first(where: { $0.id.stringValue == contactDTO.id }) {
                    contact.serverModifiedDate = Int64(Date().timeIntervalSince1970 * 1000)
                }
            }
        }
    }
}
