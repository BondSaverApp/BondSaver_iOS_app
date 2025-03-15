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
    @Environment(\.tabBarHidden) private var tabBarHidden
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = ContactMainViewModel()
    
    @State private var activeTab: ContactMainTab = .info
    
    var body: some View {
        NavigationStack {
            
            contactInfo()
            
            VStack(spacing: 0) {
                TabHeader(activeTab: $activeTab)
                
                TabView(selection: $activeTab) {
                    List {
                        aboutContactSection
                        contactInfoSection
                        extraInfoSection
                    }
                    .listStyle(.insetGrouped)
                    .tag(ContactMainTab.info)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            MeetingView(meeting: Meeting())
                            MeetingView(meeting: Meeting())
                            MeetingView(meeting: Meeting())
                        }
                        .padding(.top, 20)
                    }
                    .tag(ContactMainTab.meetings)
                    .scrollIndicators(.hidden)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.container)
            }
            .navigationTitle(Text("О контакте"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isEditViewPresented = true
                    } label: {
                        Text("Редактировать")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.left"))Назад") {
                        tabBarHidden.wrappedValue = false
                        dismiss()
                    }
                }
            }
            .onAppear {
                tabBarHidden.wrappedValue = true
                viewModel.loadData(from: contact)
            }
            .fullScreenCover(isPresented: $viewModel.isEditViewPresented) {
                ContactEditView(contact: contact, isPresented: $viewModel.isEditViewPresented)
            }
        }
    }
    
    @ViewBuilder
    func contactInfo() -> some View {
        VStack {
            avatar
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            HStack {
                contactName
            }
            .padding(10)
            
            HStack() {
                VStack {
                    Button {
                        // phone call
                    } label: {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(mainViewButtonStyle())
                    Text("Вызов")
                }
                
                VStack {
                    Button {
                        // send a message
                    } label: {
                        Image(systemName: "message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(mainViewButtonStyle())
                    Text("SMS")
                }
                
                VStack {
                    Button {
                        // video call
                    } label: {
                        Image(systemName: "video.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(mainViewButtonStyle())
                    Text("Видео")
                }
                
                
                VStack {
                    Button {
                        // send email
                    } label: {
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(mainViewButtonStyle())
                    Text("Письмо")
                }
            }
            .padding(.horizontal, 25)
        }
    }
    
    private var tagSection: some View {
        Section {
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
    
    @ViewBuilder
    private var avatar: some View {
        if let avatarData = viewModel.selectedImageData,
           let uiImage = UIImage(data: avatarData) {
            Image(uiImage: uiImage)
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
        }
    }
    
    private var aboutContactSection: some View {
        Section(header: Text("О контакте")) {
            TextField("Внешние особенности", text: $viewModel.appearanceTextField)
                .disabled(true)
            TextField("Контекст знакомства", text: $viewModel.contextTextField)
                .disabled(true)
            if let date = viewModel.dateOfBirth {
                DatePicker("Дата рождения", selection: Binding(
                    get: { date },
                    set: { _ in } // Запрещаем изменение
                ), displayedComponents: .date)
                .disabled(true)
            }
        }
    }
    
    private var contactInfoSection: some View {
        Section(header: Text("Контактная информация")) {
            TextField("Номер телефона", text: $viewModel.phoneTextField)
                .disabled(true)
            TextField("Социальная сеть", text: $viewModel.networkTextField)
                .disabled(true)
            TextField("Email", text: $viewModel.emailTextField)
                .disabled(true)
            TextField("Город", text: $viewModel.cityTextField)
                .disabled(true)
            TextField("Улица", text: $viewModel.streetTextField)
                .disabled(true)
            TextField("Дом", text: $viewModel.houseTextField)
                .disabled(true)
            TextField("Квартира", text: $viewModel.flatTextField)
                .disabled(true)
            TextField("Сайт", text: $viewModel.websiteTextField)
                .disabled(true)
        }
    }
    
    private var extraInfoSection: some View {
        Section(header: Text("Дополнительная информация")) {
            TextField("Профессия", text: $viewModel.professionTextField)
                .disabled(true)
            tagSection
            TextField("Заметка...", text: $viewModel.noteTextField)
                .disabled(true)
        }
    }

    private var meetingContextSection: some View {
        Section {
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
        } header: {
            Text("Контекст знакомства")
        }
    }
    
    private var aimSection: some View {
        Section {
            TextField("Цель общения", text: $viewModel.aimTextField)
                .disabled(true)
        } header: {
            Text("Цель общения")
        }
    }
    
    private var contactName: some View {
        Text("\(viewModel.nameTextField) \(viewModel.surnameTextField)")
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
}

struct mainViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(Color("ButtonSecondaryColor"))
            .frame(width: 50, height: 50)
            .overlay {
                configuration.label
            }
            .frame(maxWidth: .infinity)
    }
}
