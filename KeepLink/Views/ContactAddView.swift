//
//  ContactAddView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import SwiftUI

struct ContactAddView: View {
    var newContact = Contact()
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
        NavigationStack{
            Form {
                Section{
                    Menu("Выбрать тег") {
                        ForEach(Tag.allCases, id: \.rawValue){ tag in
                            Button(tag.rawValue){
                                
                            }
                        }
                    }
                }
                Section{
                    Button{
                        
                    } label: {
                        HStack{
                            newContact.photo?
                                .font(.largeTitle)
                            Text("Выбрать фото")
                        }
                    }
                }
                Section{
                    TextField("Имя", text: $nameTextField)
                    TextField("Фамилия", text: $surnameTextField)
                    TextField("Отчество", text: $patronymicTextField)
                }
                Section{
                    DatePicker("Дата рождения", selection: $dateOfBirthPicker, in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                Section{
                    TextField("", text: $ageTextField)
                } header: {
                    Text("Возраст")
                }
                Section{
                    TextField("", text: $contextTextField)
                } header: {
                    Text("Контекст знакомства")
                }
                Section{
                    TextField("", text: $aimTextField)
                } header: {
                    Text("Цель общения")
                }
                Section{
                    TextField("Заметка...", text: $noteTextField)
                }
            }
            .navigationTitle("Добавить контакт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Сохранить"){
                        
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        isPresented = false
                    }
                }
            }
        }
        
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    ContactAddView(isPresented: $isPresented)
}
