//
//  MeetingEditView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 11.03.2025.
//

import RealmSwift
import SwiftUI

struct MeetingEditView: View {
    @ObservedRealmObject var meeting: Meeting
    @StateObject private var viewModel = MeetingEditViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Button(action: {
                            viewModel.isSelectingContacts.toggle()
                        }) {
                            HStack {
                                Text(viewModel.contacsText)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(viewModel.isSelectingContacts ? 180 : 0))
                                    .animation(.easeInOut, value: viewModel.isSelectingContacts)
                            }
                        }
                    }

                    Section {
                        TextField("Описание встречи", text: $viewModel.describtion)
                    }

                    Section {
                        DatePicker("Дата встречи", selection: $viewModel.date, displayedComponents: .date)
                        DatePicker("Время встречи", selection: $viewModel.date, displayedComponents: .hourAndMinute)
                    }

                    ForEach($viewModel.topics) { $topic in
                        Section {
                            VStack(alignment: .leading) {
                                TextField("Тема обсуждения", text: $topic.title)
                                Divider()
                                TextField("Описание темы...", text: $topic.describe)
                            }

                            if topic.id == viewModel.topics.last?.id && viewModel.topics.count > 1 {
                                Button(action: viewModel.deleteTopic) {
                                    HStack {
                                        Image(systemName: "minus.circle.fill")
                                        Text("Удалить тему")
                                    }
                                }
                                .foregroundStyle(.red)
                            }
                        }
                    }

                    Button(action: viewModel.addTopic) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Добавить тему")
                        }
                    }
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)

                    Group {
                        if viewModel.isGeneratingTopic {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                Text("Генерируем...")
                                    .foregroundColor(.purple)
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 4)
                            }
                        } else {
                            Button(action: {
                                viewModel.generateTopic()
                            }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text("Сгенерировать тему")
                                }
                                .foregroundColor(.purple)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .shadow(radius: 4)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    deleteSection
                }
            }
            .navigationTitle("Редактировать встречу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        viewModel.saveMeeting(meeting)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.loadData(from: meeting)
            }
            .sheet(isPresented: $viewModel.isSelectingContacts) {
                contactListView
            }
        }
    }

    private var deleteSection: some View {
        Section {
            Button {
                viewModel.isAlertPresented = true
            } label: {
                Text("Удалить встречу")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $viewModel.isAlertPresented) {
                Alert(
                    title: Text("Удалить контакт?"),
                    message: Text("Вы уверены, что хотите удалить этот контакт?"),
                    primaryButton: .destructive(Text("Удалить")) {
                        deleteMeeting()
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("Отменить"))
                )
            }
        }
    }

    private func deleteMeeting() {
        do {
            let realm = try Realm()

            // Поиск встречи по id в текущем Realm
            guard let meetingToDelete = realm.object(ofType: Meeting.self, forPrimaryKey: meeting.id) else {
                print("Ошибка: Встреча с id \(meeting.id) не найдена в текущем Realm.")
                return
            }

            try realm.write {
                meetingToDelete.updateDeleteDate() // soft delete
            }

            dismiss()
        } catch {
            print("Ошибка удаления контакта из Realm: \(error.localizedDescription)")
        }
    }

    @ViewBuilder
    var contactListView: some View {
        List {
            ForEach(viewModel.allContacts) { contact in
                HStack(spacing: 20) {
                    HStack(spacing: 20) {
                        avatarView(for: contact)

                        VStack(alignment: .leading) {
                            Text("\(contact.firstName) \(contact.lastName)")
                                .font(.system(size: 16))
                                .fontWeight(.regular)

                            if !contact.notes.isEmpty {
                                Text(contact.notes)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .contentShape(Rectangle()) // Фиксируем область для onTapGesture
                    .onTapGesture {
                        viewModel.toggleContactSelection(contact)
                    }

                    Spacer()

                    if viewModel.selectedContacts.contains(contact) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    @ViewBuilder
    func avatarView(for contact: Contact) -> some View {
        if let avatarData = contact.avatarData,
           let uiImage = UIImage(data: avatarData)
        {
            Image(uiImage: uiImage)
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
    }
}
