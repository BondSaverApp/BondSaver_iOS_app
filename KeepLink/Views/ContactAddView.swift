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
    
    @State var nameTextField: String = ""
    @State var surnameTextField: String = ""
    @State var patronymicTextField: String = ""
    @State var contextTextField: String = ""
    @State var aimTextField: String = ""
    @State var noteTextField: String = ""
    
    @State var avatarUrl: String = ""
    
    @State var selectedTags: [String] = []
    @State var isShowingContextsOfMeeting = false
    @State var isShowingTags = false

    var body: some View {
        NavigationStack {
            Form {
                avatarSection
                
                nameSection
                
                meetingContextSection
                
                aimSection
                
                noteSection
                
                tagSection
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
            .sheet(isPresented: $isShowingContextsOfMeeting) {
                ContactMeetingPlaceView(isShowingContextsOfMeeting: $isShowingContextsOfMeeting, contextTextField: $contextTextField)
            }
            .sheet(isPresented: $isShowingTags) {
                ContactTagView(isShowingTags: $isShowingTags, selectedTags: $selectedTags)
            }
        }
    }
    
    private var tagSection: some View {
        Section {
            Button {
                isShowingTags = true
            } label: {
                
                HStack(alignment: .top){
                    Text("Теги: ")
                        .padding(.vertical, 5)
                    LazyVStack(alignment: .leading) {
                        ForEach(selectedTags, id: \.self) {
                            Text($0)
                                .padding(5)
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.systemGray6))
                                }
                        }
                    }
                }
            }
        }
    }
    
    private var avatarSection: some View {
        Section {
            Button {
                // Действие для выбора фотографии
            } label: {
                HStack {
                    if !avatarUrl.isEmpty, let url = URL(string: avatarUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    Text("Выбрать фото")
                }
            }
        }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Имя", text: $nameTextField)
            TextField("Фамилия", text: $surnameTextField)
            TextField("Отчество", text: $patronymicTextField)
        }
    }
    
    private var meetingContextSection: some View {
        Section {
            Button {
                isShowingContextsOfMeeting = true
            } label: {
                if !contextTextField.isEmpty {
                    HStack(spacing: 20){
                        Image(systemName: "plus.circle.fill")
                        Text(contextTextField)
                    }
                } else {
                    HStack(spacing: 20){
                        Image(systemName: "plus.circle.fill")
                        Text("Добавить место")
                    }
                }
            }
        } header: {
            Text("Контекст знакомства")
        }
    }
    
    private var aimSection: some View {
        Section {
            TextField("Цель общения", text: $aimTextField)
        } header: {
            Text("Цель общения")
        }
    }
    
    private var noteSection: some View {
        Section {
            TextField("Заметка...", text: $noteTextField)
        }
    }
    
    /// Сохранение контакта в базу данных Realm
    private func saveContact() {
        let realm = try! Realm()
        
        let tags = selectedTags.map { tagString -> Tag in
            let tag = Tag()
            tag.name = tagString
            return tag
        }
        
        let tagsList = RealmSwift.List<Tag>()
        tagsList.append(objectsIn: tags)
        
        let meetingPlace = MeetingPlace()
        meetingPlace.name = contextTextField
        
        try! realm.write {
            newContact.firstName = nameTextField
            newContact.lastName = surnameTextField
            newContact.middleName = patronymicTextField
            newContact.meetingContext = contextTextField
            newContact.notes = noteTextField
            newContact.appearance = aimTextField
            newContact.avatar = avatarUrl
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
