//
//  ContactMeetingPlaceView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 17.01.2025.
//

import SwiftUI

struct ContactMeetingPlaceView: View {
    @Binding var isShowingContextsOfMeeting: Bool
    @Binding var contextTextField: String

    @State private var places: [String] = UserDefaults.standard.stringArray(forKey: "MeetingPlaces") ?? [
        "Школа",
        "Университет",
        "Тренажерный зал",
        "Коворкинг",
        "Meetup",
    ]

    @State private var searchContext = ""
    @State private var isAddingNewContext = false
    @State private var newPlaceText = ""

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        if isAddingNewContext {
                            HStack {
                                TextField("Новое место", text: $newPlaceText)

                                Spacer()

                                Button {
                                    addNewContext(newPlaceText)
                                    isAddingNewContext = false
                                    newPlaceText = ""
                                } label: {
                                    Text("Добавить")
                                }
                                .disabled(newPlaceText.isEmpty)
                            }
                        } else {
                            Button {
                                isAddingNewContext = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "mappin")
                                    Text("Новое место")
                                }
                            }
                        }
                    }
                    List {
                        ForEach(filteredContexts, id: \.self) { context in
                            HStack {
                                Button {
                                    contextTextField = context
                                } label: {
                                    Text(context)
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                                if contextTextField == context {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .accentColor(.blue)
            .navigationTitle("Контекст знакомства")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchContext, prompt: "Поиск места")
            .overlay {
                if filteredContexts.isEmpty {
                    ContentUnavailableView.search(text: searchContext)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingContextsOfMeeting = false
                    } label: {
                        Text("Отменить")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingContextsOfMeeting = false
                    } label: {
                        Text("Сохранить")
                    }
                }
            }
        }
    }

    var filteredContexts: [String] {
        return searchContext == "" ? places.sorted { $0 < $1 } : places.filter { $0.localizedCaseInsensitiveContains(searchContext)
        }
    }

    func addNewContext(_ newContext: String) {
        if !newContext.isEmpty && !places.contains(newContext) {
            places.append(newContext)
            contextTextField = newContext
            UserDefaults.standard.set(places, forKey: "MeetingPlaces")
        }
    }
}

#Preview {
    @Previewable @State var isShowingContextsOfMeeting = true
    @Previewable @State var contextTextField = ""

    return ContactMeetingPlaceView(isShowingContextsOfMeeting: $isShowingContextsOfMeeting, contextTextField: $contextTextField)
}
