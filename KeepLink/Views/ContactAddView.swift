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
               
            }
            .navigationTitle("Добавить контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить") {
                        viewModel.saveContact()
                        isPresented = false
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
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ContactAddView(newContact: Contact(), isPresented: $isPresented)
}
