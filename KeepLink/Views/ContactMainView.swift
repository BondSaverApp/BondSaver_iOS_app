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
                    
                    HStack() {
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
            .onAppear { tabBarHidden.wrappedValue = true }
            .fullScreenCover(isPresented: $viewModel.isEditViewPresented) {
                ContactEditView(contact: contact, isPresented: $viewModel.isEditViewPresented)
            }
            .toolbar(.hidden, for: .tabBar)
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
    
    @ViewBuilder
    private var avatar: some View {
        if let avatarData = contact.avatarData,
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
            TextField("Внешние особенности", text: $contact.appearance)
                .disabled(true)
//            TextField("Цель общения", text: )
            TextField("Контекст знакомства", text: $contact.meetingContext)
                .disabled(true)
            DatePicker("Дата рождения", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                .disabled(true)
        }
    }
    
    private var contactInfoSection: some View {
        Section(header: Text("Контактная информация")) {
            TextField("Номер телефона", text: $viewModel.phoneTextField)
                .disabled(true)
            TextField("Социальная сеть", text: $viewModel.networkTextField)
                .disabled(true)
            TextField("Email", text: $viewModel.emailTextField)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .disabled(true)
            TextField("Город", text: $contact.city)
                .disabled(true)
            TextField("Улица", text: $contact.street)
                .disabled(true)
            TextField("Дом", text: $contact.house)
                .disabled(true)
            TextField("Квартира", text: $contact.apartment)
                .disabled(true)
            TextField("Сайт", text: $contact.website)
                .disabled(true)
        }
    }
    
    private var extraInfoSection: some View {
        Section(header: Text("Дополнительная информация")) {
            TextField("Профессия", text: $viewModel.professionTextField)
                .disabled(true)
            TextField("Здесь должны быть теги", text: $viewModel.noteTextField)
                .disabled(true)
            TextField("Заметка...", text: $viewModel.noteTextField)
                .disabled(true)
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
                .disabled(true)
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
            .frame(maxWidth: .infinity)
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
struct CustomView: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        var onWillDisappear: (() -> Void)?
    }

    let onWillDisappear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view = UIView()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.onWillDisappear = onWillDisappear
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        coordinator.onWillDisappear?()
    }
}
