//
//  ContactMainView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 07.02.2025.
//

import SwiftUI
import RealmSwift

struct ContactMainView: View {
    
    @ObservedRealmObject var contact: Contact // Привязка объекта Realm
    @Environment(\.tabBarIsVisible) var tabBarState
    @StateObject var viewModel = ContactMainViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    avatar
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    HStack {
                        nameContactStyle(name: contact.lastName, lastName: contact.firstName, middleName: contact.middleName)
                    }
                    .padding()
                    
                    HStack(spacing: 40) {
                        VStack {
                            Button {
                                // phone call
                            } label: {
                                    mainViewButtonStyle(imageName: "phone.fill")
                            }
                            Text("Вызов")
                        }
                        
                        VStack {
                            Button {
                                // send a message
                            } label: {
                                mainViewButtonStyle(imageName: "message.fill")
                            }
                            Text("SMS")
                        }
                        
                        VStack {
                            Button {
                                // video call
                            } label: {
                                mainViewButtonStyle(imageName: "video.fill")
                            }
                            Text("Видео")
                        }
                        
                        
                        VStack {
                            Button {
                                // send email
                            } label: {
                                mainViewButtonStyle(imageName: "envelope.fill")
                            }
                            Text("Письмо")
                        }
                    }
                }
                
                aboutContactSection
                
                contactInfoSection
                
                extraInfoSection
                
            }
            .navigationTitle(Text("О контакте"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isEditViewPresented = true
                    } label: {
                        Text("Редактировать")
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isEditViewPresented) {
                ContactEditView(contact: contact, isPresented: $viewModel.isEditViewPresented)
            }
        }
    }
    
    private var tagSection: some View {
        Section {
            Button {
//                isShowingTags = true
            } label: {
                HStack(alignment: .top){
                    Text("Теги: ")
                        .padding(.vertical, 5)
                    LazyVStack(alignment: .leading) {
                        
                        ForEach(viewModel.selectedTags, id: \.self) {
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
    
    private var avatar: some View {
        Button {
            // Действие для выбора фотографии
        } label: {
            if !viewModel.avatarUrl.isEmpty, let url = URL(string: viewModel.avatarUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(height: 100)
                    .foregroundColor(Color(.systemGray3))
                    
                    
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(height: 100)
                    .foregroundColor(Color(.systemGray3))
                    
            }
        }
    }
    
    private var aboutContactSection: some View {
        Section(header: Text("О контакте")) {
            TextField("Внешние особенности", text: $contact.appearance)
//            TextField("Цель общения", text: )
            TextField("Контекст знакомства", text: $contact.meetingContext)
            DatePicker("Дата рождения", selection: $viewModel.dateOfBirth, displayedComponents: .date)
        }
    }
    
    private var contactInfoSection: some View {
        Section(header: Text("Контактная информация")) {
            TextField("Номер телефона", text: $viewModel.phoneTextField)
            TextField("Социальная сеть", text: $viewModel.networkTextField)
            TextField("Email", text: $viewModel.emailTextField)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            TextField("Город", text: $contact.city)
            TextField("Улица", text: $contact.street)
            TextField("Дом", text: $contact.house)
            TextField("Квартира", text: $contact.apartment)
            TextField("Сайт", text: $contact.website)
        }
    }
    
    private var extraInfoSection: some View {
        Section(header: Text("Дополнительная информация")) {
            TextField("Профессия", text: $viewModel.professionTextField)
            TextField("Здесь должны быть теги", text: $viewModel.noteTextField)
            TextField("Заметка...", text: $viewModel.noteTextField)
        }
    }
    
    private var meetingContextSection: some View {
        Section {
            Button {
//                isShowingContextsOfMeeting = true
            } label: {
                if !viewModel.contextTextField.isEmpty {
                    HStack(spacing: 20){
                        Image(systemName: "plus.circle.fill")
                        Text(viewModel.contextTextField)
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
            TextField("Цель общения", text: $viewModel.aimTextField)
        } header: {
            Text("Цель общения")
        }
    }
    
    
}

struct mainViewButtonStyle: View {
    
    var imageName: String
    
    var body: some View {
        Circle()
            .fill(Color(.systemGray6))
            .frame(width: 50, height: 50)
            .overlay {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
    }
}

struct nameContactStyle: View {
    
    var name: String
    var lastName: String
    var middleName: String
    
    var body: some View {
        Text("\(lastName) \(name) \(middleName)")
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
}

//#Preview {
//    ContactMainView(isContactMainPresented: .co, nameTextField: <#T##Binding<String>#>, surnameTextField: <#T##Binding<String>#>, patronymicTextField: <#T##Binding<String>#>, phoneTextField: <#T##Binding<String>#>, contextTextField: <#T##Binding<String>#>, aimTextField: <#T##Binding<String>#>, noteTextField: <#T##Binding<String>#>, appearanceTextField: <#T##Binding<String>#>, cityTextField: <#T##Binding<String>#>, streetTextField: <#T##Binding<String>#>, houseTextField: <#T##Binding<String>#>, flatTextField: <#T##Binding<String>#>, websiteTextField: <#T##Binding<String>#>, networkTextField: <#T##Binding<String>#>, professionTextField: <#T##Binding<String>#>, emailTextField: <#T##Binding<String>#>, avatarUrl: <#T##Binding<String>#>, selectedTags: <#T##Binding<[String]>#>, dateOfBirth: <#T##Binding<Date>#>)
//}
