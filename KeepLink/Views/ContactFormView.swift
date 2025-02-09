//
//  ContactStructureView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import SwiftUI

struct ContactFormView: View {
    
    @Binding var nameTextField: String
    @Binding var surnameTextField: String
    @Binding var patronymicTextField: String
    @Binding var contextTextField: String
    @Binding var aimTextField: String
    @Binding var noteTextField: String
    @Binding var phoneTextField: String
    @Binding var appearanceTextField: String
    @Binding var cityTextField: String
    @Binding var streetTextField: String
    @Binding var houseTextField: String
    @Binding var flatTextField: String
    @Binding var websiteTextField: String
    @Binding var networkTextField: String
    @Binding var professionTextField: String
    @Binding var emailTextField: String
    @Binding var dateOfBirth: Date
    @Binding var avatarUrl: String
    @Binding var selectedTags: [String]
    
    @Binding var isShowingContextsOfMeeting: Bool
    @Binding var isShowingTags: Bool
    @Binding var isShowingMore: Bool
    
    var body: some View {
        Group {
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
    
    
    private var noteSection: some View {
        Section {
            TextField("Заметка...", text: $noteTextField)
        }
    }
    
    
    private var appearanceSection: some View {
        Section {
            TextField("Внешние особенности", text: $appearanceTextField)
        } header: {
            Text("Внешность")
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
        Section(header: Text("Email")) {
            TextField("Email", text: $emailTextField)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .transition(.move(edge: .top))
    }
}

