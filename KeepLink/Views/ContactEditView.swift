//
//  ContactEditView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 20.12.2024.
//

import SwiftUI
import RealmSwift

struct ContactEditView: View {
    @ObservedRealmObject var contact: Contact // Привязка объекта Realm
    @Binding var isPresented: Bool 
    @StateObject var viewModel = ContactEditViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                ContactFormView(nameTextField: $viewModel.nameTextField,
                                surnameTextField: $viewModel.surnameTextField,
                                patronymicTextField: $viewModel.patronymicTextField,
                                contextTextField: $viewModel.contextTextField,
                                noteTextField: $viewModel.noteTextField,
                                phoneTextField: $viewModel.phoneTextField,
                                appearanceTextField: $viewModel.appearanceTextField,
                                cityTextField: $viewModel.cityTextField,
                                streetTextField: $viewModel.streetTextField,
                                houseTextField: $viewModel.houseTextField,
                                flatTextField: $viewModel.flatTextField,
                                websiteTextField: $viewModel.websiteTextField,
                                networkTextField: $viewModel.networkTextField,
                                professionTextField: $viewModel.professionTextField,
                                emailTextField: $viewModel.emailTextField,
                                dateOfBirth: $viewModel.dateOfBirth,
                                selectedImageData: $viewModel.selectedImageData,
                                selectedTags: $viewModel.selectedTags,
                                isShowingContextsOfMeeting: $viewModel.isShowingContextsOfMeeting,
                                isShowingTags: $viewModel.isShowingTags)
                deleteSection
            }
            .navigationTitle("Редактировать контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить") {
                        viewModel.saveContact(contact)
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                viewModel.loadData(from: contact)
            }
            .sheet(isPresented: $viewModel.isShowingContextsOfMeeting) {
                ContactMeetingPlaceView(isShowingContextsOfMeeting: $viewModel.isShowingContextsOfMeeting,
                                        contextTextField: $viewModel.contextTextField)
            }
            .sheet(isPresented: $viewModel.isShowingTags) {
                ContactTagView(isShowingTags: $viewModel.isShowingTags,
                               selectedTags: $viewModel.selectedTags)
            }
        }
    }

    private var deleteSection: some View {
        Section {
            Button {
                viewModel.isAlertPresented = true
            } label: {
                Text("Удалить контакт")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $viewModel.isAlertPresented) {
                Alert(
                    title: Text("Удалить контакт?"),
                    message: Text("Вы уверены, что хотите удалить этот контакт?"),
                    primaryButton: .destructive(Text("Удалить")) {
                        deleteContact()
                        isPresented = false
                    },
                    secondaryButton: .cancel(Text("Отменить"))
                )
            }
        }
    }
    
    private func deleteContact() {
        do {
            let realm = try Realm()
            
            // Поиск контакта по id в текущем Realm
            guard let contactToDelete = realm.object(ofType: Contact.self, forPrimaryKey: contact.id) else {
                print("Ошибка: Контакт с id \(contact.id) не найден в текущем Realm.")
                return
            }
            
            try realm.write {
                contactToDelete.updateDeleteDate() // Обновляем дату удаления найденного контакта
            }
            
            isPresented = false
        } catch {
            print("Ошибка удаления контакта из Realm: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
