//
//  MeetingView.swift
//  KeepLink
//
//  Created by Maria Mayorova on 15.02.2025.
//

import SwiftUI

struct MeetingView: View {
    var meeting: Meeting

    var isOnMeetingsView: Bool
    private var state: State
    
    enum State: String {
        case planned = "Запланировано"
        case inProgress = "Сейчас"
        case finished = "Встреча закончилась"
    }
    
    init(meeting: Meeting, isOnMeetingsView: Bool = false) {
        self.meeting = meeting
        self.isOnMeetingsView = isOnMeetingsView
        
        switch Date().compare(meeting.date) {
        case .orderedAscending:
            state = .planned
        case .orderedDescending:
            state = .finished
        case .orderedSame:
            state = .inProgress
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "button.programmable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12)
                Text(state.rawValue)
            }
            .foregroundColor(stateColor)
            Text(meeting.date.formatted(date: .long, time: .shortened))
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.bottom, 6)
            Group {
                ForEach(meeting.topics, id: \.self) { topic in
                    HStack {
                        Image(systemName: "circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 5)
                        Text(topic.title)
                            .font(.caption2)
                    }
                }
            }
            
            if isOnMeetingsView {
                contactAvatars
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2)
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        )
        .padding(1)
    }
    
    private var contactAvatars: some View {
        return HStack {
            ForEach(meeting.contactIds, id: \.self) { id in
                let contact = DataBase.shared.contacts.first { $0.id == id } ?? Contact()
                avatarView(for: contact)
            }
        }
    }
    
    private var stateColor: Color {
        switch state {
        case .planned:
            return Color.purple
        case .inProgress:
            return Color.mint
        case .finished:
            return Color.black.opacity(0.5)
        }
    }
    
    @ViewBuilder
    func avatarView(for contact: Contact) -> some View {
        if let avatarData = contact.avatarData,
           let uiImage = UIImage(data: avatarData) {
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
