//
//  MeetingsViewModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 08.03.2025.
//

import SwiftUI

final class MeetingsViewModel: ObservableObject {
    @Published var showsAddView = false
    @Published var selectedMeetingForEdit: Meeting? = nil
    
    func selectMeeting(_ meeting: Meeting) {
        selectedMeetingForEdit = meeting
    }
    
    func showAddView() {
        showsAddView = true
    }
}
