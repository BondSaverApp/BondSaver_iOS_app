//
//  ContactsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI
import RealmSwift

struct ContactAddView: View {
    @ObservedRealmObject var newContact = Contact()
    @Binding var isPresented: Bool
    @StateObject var viewModel = ContactAddViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                ContactFormView(nameTextField: $viewModel.nameTextField,
                                surnameTextField: $viewModel.surnameTextField,
                                patronymicTextField: $viewModel.patronymicTextField,
                                contextTextField: $viewModel.contextTextField,
                                aimTextField: $viewModel.aimTextField,
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
                                avatarUrl: $viewModel.avatarUrl,
                                selectedTags: $viewModel.selectedTags,
                                isShowingContextsOfMeeting: $viewModel.isShowingContextsOfMeeting,
                                isShowingTags: $viewModel.isShowingTags,
                                isShowingMore: $viewModel.isShowingMore)
               
            }
            .navigationTitle("Добавить контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить") {
                        saveContact()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingContextsOfMeeting) {
                ContactMeetingPlaceView(isShowingContextsOfMeeting: $viewModel.isShowingContextsOfMeeting, contextTextField: $viewModel.contextTextField)
            }
            .sheet(isPresented: $viewModel.isShowingTags) {
                ContactTagView(isShowingTags: $viewModel.isShowingTags, selectedTags: $viewModel.selectedTags)
            }
        }
    }
    
    
    /// Сохранение контакта в базу данных Realm
    private func saveContact() {
        let realm = try! Realm()
        
        let tags = viewModel.selectedTags.map { tagString -> Tag in
            let tag = Tag()
            tag.name = tagString
            return tag
        }
        
        let tagsList = RealmSwift.List<Tag>()
        tagsList.append(objectsIn: tags)
        
        let meetingPlace = MeetingPlace()
        meetingPlace.name = viewModel.contextTextField
        
        try! realm.write {
            newContact.firstName = viewModel.nameTextField
            newContact.lastName = viewModel.surnameTextField
            newContact.middleName = viewModel.patronymicTextField
            newContact.meetingContext = viewModel.contextTextField
            newContact.notes = viewModel.noteTextField
            newContact.appearance = viewModel.appearanceTextField
            newContact.avatar = viewModel.avatarUrl
            newContact.tags = tagsList
            newContact.meetingPlace = meetingPlace
            
            realm.add(newContact)
        }
        isPresented = false
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ContactAddView(newContact: Contact(), isPresented: $isPresented)
}
