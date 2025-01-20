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
    
    @State var nameTextField: String = ""
    @State var surnameTextField: String = ""
    @State var patronymicTextField: String = ""
    @State var dateOfBirthPicker: Date = Date.now
    @State var contextTextField: String = ""
    @State var aimTextField: String = ""
    @State var noteTextField: String = ""
    @State var avatarUrl: String = "" // URL для аватара (опционально)
    
    @State var selectedTags: [String] = []
    @State var isShowingContextsOfMeeting = false
    @State var isShowingTags = false
    
    @State private var isAlertPresented = false // адерт для удаления
    
    var body: some View {
        NavigationStack {
            Form {
                avatarSection
                
                nameSection
                
                meetingContextSection
                
                aimSection
                
                noteSection
                
                tagSection
                
                deleteSection
            }
            .navigationTitle("Редактировать контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить") {
                        saveContact()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                nameTextField = contact.firstName
                surnameTextField = contact.lastName
                patronymicTextField = contact.middleName
                aimTextField = contact.appearance
                noteTextField = contact.notes
                avatarUrl = contact.avatar
                selectedTags = contact.tags.map { tag in
                    tag.name
                }
                contextTextField = contact.meetingPlace?.name ?? ""
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
    
    private var deleteSection: some View {
        Section {
            Button {
                isAlertPresented = true
            } label: {
                Text("Удалить контакт")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $isAlertPresented) {
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

    
    /// Сохранение изменений в базе данных
    private func saveContact() {
        guard let thawedContact = contact.thaw() else {
            print("Ошибка: Не удалось разморозить объект.")
            return
        }
        
        do {
            let realm = try Realm()
            
            let tags = selectedTags.map { tagString -> Tag in
                let tag = Tag()
                tag.name = tagString
                return tag
            }
            
            let tagsList = RealmSwift.List<Tag>()
            tagsList.append(objectsIn: tags)
            
            let meetingPlace = MeetingPlace()
            meetingPlace.name = contextTextField
            
            try realm.write {
                thawedContact.firstName = nameTextField
                thawedContact.lastName = surnameTextField
                thawedContact.middleName = patronymicTextField
                thawedContact.meetingContext = contextTextField
                thawedContact.appearance = aimTextField
                thawedContact.notes = noteTextField
                thawedContact.tags = tagsList
                thawedContact.meetingPlace = meetingPlace
            }
            isPresented = false
        } catch {
            print("Ошибка сохранения в Realm: \(error.localizedDescription)")
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
                realm.delete(contactToDelete)
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
