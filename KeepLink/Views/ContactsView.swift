//
//  ContactsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContactsView: View {
    
    @State private var contacts = [
        Contact(name: "Вася", surname: "Пупкин"),
        Contact(name: "Олег", surname: "Петров"),
        Contact(name: "Ян"),
        Contact(name: "Яна", surname: "Алексеева"),
        Contact(name: "Марина"),
        Contact(name: "Павел"),
        Contact(name: "Екатерина", surname: "Сидорова"),
        Contact(name: "Алексей", surname: "Заровкин"),
        Contact(name: "Валентин", surname: "Чертков"),
        Contact(name: "Элина"),
        Contact(name: "Петр", surname: "Федулин"),
        Contact(name: "Екатерина", surname: "Будзинская"),
        Contact(name: "Данил", surname: "Щербаков"),
        Contact(name: "Наталья"),
        Contact(name: "Оксана", surname: "Ногти"),
    ]
    
    @State private var searchText = ""
    @State private var selectedTag: String = "Выбрать тег "
    @State private var selectedContact: Contact?
    @State var isEditViewPresented: Bool = false
        
    
    var filteredContacts: [Contact] {
        guard !searchText.isEmpty else { return contacts }
        return contacts.filter { ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false) || ($0.surname?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if filteredContacts.isEmpty {
                    Text("По вашему запросу ничего не найдено")
                } else {
                    List(filteredContacts) { contact in
                        HStack (spacing: 20) {
                            
                            contact.avatarView
                            
                            Text("\(contact.name ?? "") \(contact.surname ?? "")")
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                            
                            Spacer()
                            phoneButton
                            editButton(for: contact)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(.bottom, 90)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: menuButton)
            .searchable(text: $searchText, prompt: "Найти контакт...")
        }
        .fullScreenCover(isPresented: $isEditViewPresented, onDismiss: {selectedContact = nil}) {
            ContactEditView(contact: selectedContact!, isPresented: $isEditViewPresented)
        }
        .onChange(of: selectedContact) { _, newValue in
            if newValue != nil {
                isEditViewPresented = true
            }
        }
    }
    
    var phoneButton: some View {
        Button {
            // some action
        } label: {
            Image(systemName: "phone.fill")
                .scaledToFit()
                .background(Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 30, height: 30)
                )
        }
    }
    
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
    
    var menuButton: some View {
            Menu {
                Button("Тег 1") {
                    selectedTag = "Тег 1"
                }
                Button("Тег 2") {
                    selectedTag = "Тег 2"
                }
                Button("Тег 3") {
                    selectedTag = "Тег 3"
                }
            } label: {
                HStack {
                    Text(selectedTag)
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down") // Стрелочка вниз
                        .foregroundColor(.black)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
}


#Preview {
    ContactsView()
}
