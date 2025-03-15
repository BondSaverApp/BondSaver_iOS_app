//
//  ContactStructureView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 09.02.2025.
//

import SwiftUI
import PhotosUI
import SwiftyCrop

struct ContactFormView: View {
    @Binding var nameTextField: String
    @Binding var surnameTextField: String
    @Binding var patronymicTextField: String
    @Binding var contextTextField: String
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
    @Binding var selectedImageData: Data?
    @Binding var selectedTags: [String]
    
    @Binding var isShowingContextsOfMeeting: Bool
    @Binding var isShowingTags: Bool
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var showPhotosPicker = false
    @State var showImageCropper = false
    @State var showActionSheet = false
    
    var body: some View {
        Group {
            avatarSection
            
            nameSection
            
            phoneSection
            
            meetingContextSection
            
            
            appearanceSection
            
            noteSection
            
            tagSection
            
            dateSection
            
            adressSection
            
            websiteSection
            
            networkSection
            
            professionSection
            
            emailSection
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
            HStack {
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
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
                
                Button("Выбрать фото") {
                    if let selectedImageData,
                       let _ = UIImage(data: selectedImageData) {
                        showActionSheet = true
                    } else {
                        showPhotosPicker = true
                    }
                }
                .confirmationDialog("Выберите действие", isPresented: $showActionSheet, titleVisibility: .visible) {
                    Button("Обрезать текущее фото") {
                        showImageCropper = true
                    }
                    Button("Выбрать новое фото") {
                        showPhotosPicker = true
                    }
                    Button("Отмена", role: .cancel) {}
                }
                .fullScreenCover(isPresented: $showImageCropper) {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        SwiftyCropView(
                            imageToCrop: uiImage,
                            maskShape: .circle,
                            configuration: SwiftyCropConfiguration(
                                maxMagnificationScale: 4.0,
                                maskRadius: 130.0,
                                cropImageCircular: false,
                                rotateImage: false,
                                zoomSensitivity: 10.0,
                                rectAspectRatio: 1
                            )
                        ) { croppedImage in
                            // Do something with the returned, cropped image
                            self.selectedImageData = compressImage(croppedImage)
                        }
                    }
                }
                .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            showImageCropper = true
                        }
                    }
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

func compressImage(_ image: UIImage?, maxSizeMB: Double = 1.0) -> Data? {
    let maxSizeBytes = Int(maxSizeMB * 1024 * 1024) // 1MB в байтах
    var compression: CGFloat = 1.0 // Начинаем с максимального качества
    if let image {
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > maxSizeBytes, compression > 0.1 {
            compression -= 0.1 // Понижаем качество на 10%
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    return .none
}
