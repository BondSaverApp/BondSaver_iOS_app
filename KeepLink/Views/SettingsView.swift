//
//  SettingsView.swift
//  KeepLink
//
//  Created by Андрей Степанов on 17.05.2025.
//


//
//  SettingsView.swift
//  KeepLink
//
//  Created by ChatGPT on 17.05.2025.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("dailyReminderHour") private var dailyReminderHour: Int = 9

    @State private var showHourPicker: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Уведомления") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Включить напоминания", systemImage: "bell")
                    }
                    .onChange(of: notificationsEnabled) { value in
                        if value {
                            scheduleReminderTask()
                        } else {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    }

                    HStack {
                        Label("Время проверки", systemImage: "clock")
                        Spacer()
                        Button("\(dailyReminderHour):00") { showHourPicker.toggle() }
                            .buttonStyle(.borderless)
                    }
                }

                Section("Отладка") {
                    Button("Показать очередь уведомлений") {
                        debugPrintPendingNotifications()
                    }
                    Button("Очистить отправленные уведомления") {
                        clearReminders()
                    }
                    .tint(.red)
                }
            }
            .navigationTitle("Настройки")
            .sheet(isPresented: $showHourPicker) {
                HourPickerView(selectedHour: $dailyReminderHour)
                    .presentationDetents([.medium])
                    .onDisappear {
                        rescheduleTaskFor(hour: dailyReminderHour)
                    }
            }
        }
    }

    // MARK: - Helpers

    private func rescheduleTaskFor(hour: Int) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleReminderTask() // simple: re‑schedule with new begin date; production could set earliestBeginDate to next chosen hour
    }

    private func debugPrintPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📦 Pending: \(requests.count)")
            for r in requests { print(r) }
        }
    }

    private func clearReminders() {
        guard let realm = try? Realm() else { return }
        let all = realm.objects(Reminder.self)
        try? realm.write { realm.delete(all) }
    }
}

// Simple hour picker
struct HourPickerView: View {
    @Binding var selectedHour: Int

    var body: some View {
        Picker("Время", selection: $selectedHour) {
            ForEach(0..<24) { Text("\($0):00").tag($0) }
        }
        .pickerStyle(.wheel)
    }
}

#Preview {
    SettingsView()
}
