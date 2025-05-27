//
//  NotificationsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.05.2025.
//

import RealmSwift
import SwiftUI

/// Экран, показывающий локально сохранённые напоминания (Reminder)
struct NotificationsView: View {
    @ObservedResults(Reminder.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false))
    private var reminders

    var body: some View {
        NavigationStack {
            if reminders.isEmpty {
                ContentUnavailableView(
                    "Пока нет напоминаний",
                    systemImage: "bell.slash",
                    description: Text("Когда придёт время предложить встречу, вы увидите уведомление здесь.")
                )
            } else {
                List {
                    ForEach(reminders) { reminder in
                        ReminderRow(reminder: reminder)
                    }
                    .onDelete { indexSet in
                        delete(at: indexSet)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Уведомления")
                .toolbar { EditButton() }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        guard let realm = reminders.realm else { return }
        try? realm.write {
            realm.delete(reminders[offsets.first!])
        }
    }
}

// MARK: - Row

struct ReminderRow: View {
    let reminder: Reminder

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reminder.title)
                .font(.headline)
                .foregroundColor(.accentColor)
            Text(reminder.body)
                .font(.subheadline)
                .foregroundStyle(.primary)
            Text(reminder.date.formatted(date: .long, time: .shortened))
                .font(.caption)
                .foregroundColor(.secondary)
            if !reminder.relatedContactIds.isEmpty {
                contactsAvatars
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1)
        )
    }

    // MARK: Avatars

    private var contactsAvatars: some View {
        HStack(spacing: -8) {
            ForEach(reminder.relatedContactIds.prefix(5), id: \ .self) { id in
                if let contact = DataBase.shared.contacts.first(where: { $0.id == id }) {
                    avatar(for: contact)
                }
            }
        }
    }

    @ViewBuilder
    private func avatar(for contact: Contact) -> some View {
        if let data = contact.avatarData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.gray.opacity(0.6))
        }
    }
}

// MARK: - Previews

#Preview {
    NotificationsView()
}
