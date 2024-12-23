//
//  ContactModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import Foundation
import SwiftUI

struct Contact: Identifiable, Equatable {
    let id = UUID()
    var name: String?
    var surname: String?
    var secondName: String?
    
    var tag: Tag = .defaultTag
    var photo: Image? = Image(systemName: "person.circle")
    
    var avatarColor: Color = .random()
    
    
    var dateOfBirth: Date?
    var age: Int?
    
    var meetingContext: String?
    var communicationAims: String?
    
    var notes: String?
    
    mutating func setTag(_ tag: Tag){
        self.tag = tag
    }
    
    var avatarView: some View {
        
        let initial = String(name?.prefix(1) ?? "")
        
        return Circle()
                .fill(avatarColor)
                .frame(width: 30, height: 30) // Размер круга
                .overlay(
                    Text(initial)
                        .font(.headline) // Шрифт текста
                        .foregroundColor(.white) // Цвет текста
                )
    }
}

extension Color {
    static func random() -> Color {
        let colors: [Color] = [
            Color.pink.opacity(0.3),
            Color.blue.opacity(0.3),
            Color.green.opacity(0.3),
            Color.orange.opacity(0.3),
            Color.purple.opacity(0.3),
            Color.yellow.opacity(0.3)]
        
            return colors.randomElement() ?? .black // Если массив пустой, возвращаем черный цвет
    }
}
