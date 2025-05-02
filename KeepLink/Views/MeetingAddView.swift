//
//  MeetingAddView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 11.03.2025.
//

import SwiftUI

struct MeetingAddView: View {
    @StateObject private var viewModel = MeetingAddViewModel()
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
                }
            }
            .navigationTitle("Добавить встречу")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        viewModel.saveMeeting()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $viewModel.isSelectingContacts) {
                contactListView
            }
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

#Preview {
    MeetingAddView()
}
