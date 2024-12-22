//
//  ContactEditView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 20.12.2024.
//

import SwiftUI

struct ContactEditView: View {
    var contact: Contact
    @Binding var isPresented: Bool
    
    @State var nameTextField: String = ""
    @State var surnameTextField: String = ""
    @State var patronymicTextField: String = ""
    @State var dateOfBirthPicker: Date = Date.now
    @State var ageTextField: String = ""
    @State var contextTextField: String = ""
    @State var aimTextField: String = ""
    @State var noteTextField: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Menu("Тег: \(contact.tag.rawValue)") {
                        ForEach(Tag.allCases, id: \.rawValue) { tag in
                            Button(tag.rawValue) {
                                // Выбор тега
                            }
                        }
                    }
                }
                Section {
                    Button {
                        // Выбор фото
                    } label: {
                        HStack {
                            contact.photo
                                .font(.largeTitle)
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
                    DatePicker("Дата рождения", selection: $dateOfBirthPicker, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                Section {
                    TextField("", text: $ageTextField)
                } header: {
                    Text("Возраст")
                }
                Section {
                    TextField("", text: $contextTextField)
                } header: {
                    Text("Контекст знакомства")
                }
                Section {
                    TextField("", text: $aimTextField)
                } header: {
                    Text("Цель общения")
                }
                Section {
                    TextField("Заметка...", text: $noteTextField)
                }
            }
            .navigationTitle("Редактировать контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить") {
                        // Сохранение изменений
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        isPresented = false
                        print(isPresented)
                    }
                }
            }
            .onAppear {
                nameTextField = contact.name ?? ""
                surnameTextField = contact.surname ?? ""
                patronymicTextField = contact.secondName ?? ""
                dateOfBirthPicker = contact.dateOfBirth ?? Date()
                contextTextField = contact.meetingContext ?? ""
                aimTextField = contact.communicationAims ?? ""
                noteTextField = contact.notes ?? ""
            }
        }
    }
}
#Preview {
    @Previewable @State var isPresented: Bool = true
    
    
    ContactEditView(contact: Contact(name: "andrey",
                                     surname: "stepanov",
                                     secondName: "sergeevich",
                                     tag: .defaultTag,
                                     photo: nil,
                                     avatarColor: .blue,
                                     dateOfBirth: nil,
                                     age: nil,
                                     meetingContext: "asd",
                                     communicationAims: "awad",
                                     notes: "blablabla"),
                    isPresented: $isPresented)
}
