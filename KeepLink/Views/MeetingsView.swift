//
//  MeetingsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 08.03.2025.
//

import RealmSwift
import SwiftUI

struct MeetingsView: View {
    @StateObject private var viewModel = MeetingsViewModel()
    @ObservedResults(Meeting.self, where: { $0.deleteDate == nil }) var meetings

    var body: some View {
        NavigationStack {
            List {
                ForEach(meetings) { meeting in
                    MeetingView(meeting: meeting, isOnMeetingsView: true)
                        .onTapGesture {
                            viewModel.selectMeeting(meeting)
                        }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Создать") {
                        viewModel.showAddView()
                    }
                }
            }
            .fullScreenCover(item: $viewModel.selectedMeetingForEdit) { meeting in
                MeetingEditView(meeting: meeting)
            }
            .fullScreenCover(isPresented: $viewModel.showsAddView) {
                MeetingAddView()
            }
        }
    }
}

#Preview {
    MeetingsView()
}
