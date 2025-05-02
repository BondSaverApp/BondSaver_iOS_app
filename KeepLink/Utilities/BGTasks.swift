//
//  BGTasks.swift
//  KeepLink
//
//  Created by Андрей Степанов on 02.05.2025.
//

import BackgroundTasks
import NotificationCenter
import RealmSwift

func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.keeplink.send-reminders", using: nil) { task in
        handleReminderTask(task: task as! BGProcessingTask)
    }
}

func scheduleReminderTask() {
    let request = BGProcessingTaskRequest(identifier: "com.keeplink.send-reminders")
    request.requiresNetworkConnectivity = false
    request.requiresExternalPower = false
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 24) // через 24 часа

    do {
        try BGTaskScheduler.shared.submit(request)
        print("Reminder task scheduled")
    } catch {
        print("Failed to schedule reminder task: \(error)")
    }
}

func handleReminderTask(task: BGProcessingTask) {
    scheduleReminderTask()

    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1

    task.expirationHandler = {
        queue.cancelAllOperations()
    }

    queue.addOperation {
        do {
            let realm = try Realm()
            let now = Date()
            let contacts = realm.objects(Contact.self).filter { contact in
                let createdAt = contact.id.timestamp
                let hoursSinceCreation = abs(now.timeIntervalSince(createdAt)) / 3600
                return hoursSinceCreation >= 40 && hoursSinceCreation <= 56
            }

            guard !contacts.isEmpty else {
                task.setTaskCompleted(success: true)
                return
            }

            let names = contacts.prefix(3).map { $0.firstName }
            let title = "Развивайте полезные связи"
            let body = "Вы недавно познакомились с \(names.joined(separator: ", ")), предложите им встретиться"

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)

            let reminder = Reminder()
            reminder.title = title
            reminder.body = body
            reminder.date = now
            reminder.relatedContactIds.append(objectsIn: contacts.map { $0.id })

            try realm.write {
                realm.add(reminder)
            }

            task.setTaskCompleted(success: true)
            print("Reminder task executed")
        } catch {
            print("Failed to handle reminder task: \(error)")
            task.setTaskCompleted(success: false)
        }
    }
}
