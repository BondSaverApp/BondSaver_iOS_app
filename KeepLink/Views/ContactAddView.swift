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
    @State var phoneTextField: String = ""
    @State var appearanceTextField: String = ""
    @State var cityTextField: String = ""
    @State var streetTextField: String = ""
    @State var houseTextField: String = ""
    @State var flatTextField: String = ""
    @State var websiteTextField: String = ""
    @State var networkTextField: String = ""
    @State var professionTextField: String = ""
    @State var emailTextField: String = ""
    @State var dateOfBirth = Date()
    
    
    @State var avatarUrl: String = ""
    
    @State var selectedTags: [String] = []
    @State var isShowingContextsOfMeeting = false
    @State var isShowingTags = false
    @State var isShowingMore = false

    var body: some View {
        NavigationStack {
            Form {
                avatarSection
                
                nameSection
                
                phoneSection
                
                meetingContextSection
                
                aimSection
                
                appearanceSection
                
                noteSection
                
                tagSection
                
                if isShowingMore {
                    dateSection
                    
                    adressSection
                    
                    websiteSection
                    
                    networkSection
                    
                    professionSection
                    
                    emailSection
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isShowingMore.toggle()
                    }
                } label: {
                    Text(isShowingMore ? "Show Less" : "Show More...")
                }
               
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
    
    private var phoneSection: some View {
        Section {
            TextField("Номер телефона", text: $phoneTextField)
        } header: {
            Text("Номер телефона")
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
    
    private var appearanceSection: some View {
        Section {
            TextField("Внешние особенности", text: $appearanceTextField)
        } header: {
            Text("Внешность")
        }
    }
    
    private var noteSection: some View {
        Section {
            TextField("Заметка...", text: $noteTextField)
        }
    }
    
    private var dateSection: some View {
        Section {
            DatePicker("Дата рождения", selection: $dateOfBirth, displayedComponents: .date)
        } header: {
            Text("Дата")
        }
        .transition(.move(edge: .top))
    }
    
    private var adressSection: some View {
        Section {
            TextField("Город", text: $cityTextField)
            TextField("Улица", text: $streetTextField)
            TextField("Дом", text: $houseTextField)
            TextField("Квартира", text: $flatTextField)
        } header: {
            Text("Адрес")
        }
        .transition(.move(edge: .top))
    }
    
    private var websiteSection: some View {
        Section {
            TextField("Сайт", text: $websiteTextField)
        } header: {
            Text("Сайт")
        }
        .transition(.move(edge: .top))
    }
    
    private var networkSection: some View {
        Section {
            TextField("Социальная сеть", text: $networkTextField)
        } header: {
            Text("Социальная сеть")
        }
        .transition(.move(edge: .top))
    }
    
    private var professionSection: some View {
        Section {
            TextField("Профессия", text: $professionTextField)
        } header: {
            Text("Профессия")
        }
        .transition(.move(edge: .top))
    }
    
    private var emailSection: some View {
        Section {
            TextField("Email", text: $emailTextField)
        } header: {
            Text("Email")
        }
        .transition(.move(edge: .top))
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
