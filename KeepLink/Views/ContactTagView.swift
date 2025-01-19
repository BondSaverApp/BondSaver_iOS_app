//
//  ContactTagView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 18.01.2025.
//

import SwiftUI

struct ContactTagView: View {
    
    @Binding var isShowingTags: Bool
    @Binding var selectedTags: [String]
    
    @State private var tags: [String] = UserDefaults.standard.stringArray(forKey: "Tags") ?? [
        "Web",
        "iOS",
        "Дизайн",
        "Бизнес"
    ]
    
    @State var searchTag = ""
    @State private var isAddingNewTag = false
    @State private var newTagText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        if isAddingNewTag {
                            HStack {
                                TextField("Новый тег", text: $newTagText)
                                
                                Spacer()
                                
                                Button {
                                    addNewTag(newTagText)
                                    isAddingNewTag = false
                                    newTagText = ""
                                } label: {
                                    Text("Добавить")
                                }
                                .disabled(newTagText.isEmpty)
                            }
                        } else {
                            Button {
                                isAddingNewTag = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "tag")
                                    Text("Новый тег")
                                }
                            }
                        }
                    }
                        List {
                            ForEach(filteredTags, id: \.self) { tag in
                                HStack {
                                    Button {
                                        if selectedTags.contains(tag) {
                                            selectedTags.removeAll { $0 == tag }
                                        } else {
                                            selectedTags.append(tag)
                                        }
                                    } label: {
                                        Text(tag)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Spacer()
                                    if selectedTags.contains(tag) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                    }
                }
                .accentColor(.blue)
                .navigationTitle(Text("Tags"))
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchTag, prompt: "Поиск тега")
                .overlay {
                    if filteredTags.isEmpty {
                        ContentUnavailableView.search(text: searchTag)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button {
                            isShowingTags = false
                        } label: {
                            Text("Отменить")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            isShowingTags = false
                        } label: {
                            Text("Сохранить")
                        }
                    }
                }
            }
        }
    }
    
    var filteredTags: [String] {
        guard !searchTag.isEmpty else {  return tags.sorted { $0 < $1 } }
        return tags.filter { $0.localizedCaseInsensitiveContains(searchTag) }
    }
    
    func addNewTag(_ newTag: String) {
        if !newTag.isEmpty && !tags.contains(newTag) {
            tags.append(newTag)
            selectedTags.append(newTag)
            UserDefaults.standard.set(tags, forKey: "Tags")
        }
    }
    
}

#Preview {
    @Previewable @State var isShowingTags = true
    @Previewable @State var selectedTags = ["web", "iOS"]

    return ContactTagView(isShowingTags: $isShowingTags, selectedTags: $selectedTags)
}
