//
//  ContactsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI
import RealmSwift



struct ContactsView: View {
    @ObservedResults(Contact.self) var contacts
    @EnvironmentObject var tabBarViewModel: CustomTabBarViewModel
    
    @State private var searchText = ""
    @State private var selectedTag: String = "Выбрать тег"
    @State private var selectedContact: Contact?
    @State private var isContactMainPresented: Bool = false
   
    
    @State private var tags: [String] = UserDefaults.standard.stringArray(forKey: "Tags") ?? [
        "Web",
        "iOS",
        "Дизайн",
        "Бизнес"
    ]
    
    var filteredContacts: Results<Contact> {
        var result = contacts
        
        // Фильтрация по тексту поиска
        if !searchText.isEmpty {
            result = result.filter("firstName CONTAINS[c] %@ OR lastName CONTAINS[c] %@", searchText, searchText)
        }
        
        // Фильтрация по выбранному тегу
        if selectedTag != "Выбрать тег" {
            result = result.filter("ANY tags.name == %@", selectedTag)
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if filteredContacts.isEmpty {
                    Text("По вашему запросу ничего не найдено")
                        .foregroundColor(.gray)
                } else {
                    contactListView
                }
            }
            .safeAreaPadding(.bottom, 90)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: menuButton)
            .searchable(text: $searchText, prompt: "Найти контакт...")
            .onAppear {
                // Добавляем наблюдателя обновления тегов
                NotificationCenter.default.addObserver(forName: .tagsUpdated, object: nil, queue: .main) { _ in
                    updateTags()
                }
            }
            .onDisappear {
                // Удаляем наблюдателя
                NotificationCenter.default.removeObserver(self, name: .tagsUpdated, object: nil)
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedContact != nil },
                set: { if !$0 { selectedContact = nil } }
            )) {
                if let selectedContact {
                    ContactMainView(contact: selectedContact)
                }
            }
        }
    }
    
    @ViewBuilder
    var contactListView: some View {
        List {
            ForEach(filteredContacts) { contact in
                HStack(spacing: 20) {
                    avatarView(for: contact)
                    
                    VStack(alignment: .leading) {
                        Text("\(contact.firstName) \(contact.lastName)")
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        
                        if !contact.notes.isEmpty {
                            Text(contact.notes)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    phoneButton(for: contact)
                    editButton(for: contact)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // Вспомогательное представление для аватара
    @ViewBuilder
    func avatarView(for contact: Contact) -> some View {
        if !contact.avatar.isEmpty, let url = URL(string: contact.avatar), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
    }
    
    // Кнопка вызова
    func phoneButton(for contact: Contact) -> some View {
        Button {
            if let phoneNumber = contact.phoneNumbers.first?.number {
                if let url = URL(string: "tel://\(phoneNumber)") {
                    UIApplication.shared.open(url)
                }
            }
        } label: {
            Image(systemName: "phone.fill")
                .scaledToFit()
                .background(Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 30, height: 30)
                )
        }
    }
    
    // Кнопка редактирования
    func editButton(for contact: Contact) -> some View {
        Button {
            selectedContact = contact
        } label: {
            Image(systemName: "square.and.pencil")
                .scaledToFit()
                .foregroundColor(.blue)
                .background(Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 30, height: 30)
                )
        }
    }
    
    // Кнопка выбора тега
    var menuButton: some View {
        Menu {
            Button("Выбрать тег") {
                selectedTag = "Выбрать тег"
            }
        
            ForEach(tags, id: \.self) { tag in
                Button(tag) {
                    selectedTag = tag
                }
            }
        } label: {
            HStack {
                Text(selectedTag)
                    .foregroundColor(.black)
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
            }
            .padding(10)
            .cornerRadius(8)
        }
    }
    
    private func updateTags() {
        tags = UserDefaults.standard.stringArray(forKey: "Tags") ?? []
    }
}


#Preview {
    ContactsView()
}
