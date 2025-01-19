import SwiftUI
import RealmSwift

struct ContactAddView: View {
    @ObservedRealmObject var newContact = Contact() // Используем для привязки к Realm
    @Binding var isPresented: Bool // Для закрытия окна добавления контакта
    
    @State var nameTextField: String = ""
    @State var surnameTextField: String = ""
    @State var patronymicTextField: String = ""
    @State var contextTextField: String = ""
    @State var aimTextField: String = ""
    @State var noteTextField: String = ""
    
    @State var avatarUrl: String = "" // URL для аватара (если используется)
    
    @State var selectedTags: [String] = []
    @State var isShowingContextsOfMeeting = false
    @State var isShowingTags = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        isShowingTags = true
                    } label: {
                        HStack {
                            Text("Теги: ")
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
                
                Section {
                    TextField("Имя", text: $nameTextField)
                    TextField("Фамилия", text: $surnameTextField)
                    TextField("Отчество", text: $patronymicTextField)
                }
                
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
                
                Section {
                    TextField("Цель общения", text: $aimTextField)
                } header: {
                    Text("Цель общения")
                }
                
                Section {
                    TextField("Заметка...", text: $noteTextField)
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
            newContact.avatar = avatarUrl // Сохраняем URL аватара
            newContact.tags = tagsList
            newContact.meetingPlace = meetingPlace
            
            // Сохраняем объект в базу данных
            realm.add(newContact)
        }
        
        // Закрываем окно после сохранения
        isPresented = false
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ContactAddView(newContact: Contact(), isPresented: $isPresented)
}
