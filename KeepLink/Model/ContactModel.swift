//
//  ContactModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import Foundation
import SwiftUI

struct Contact{
    var name: String?
    var surname: String?
    var secondName: String?
    
    var tag: Tag = .defaultTag
    var photo: Image? = Image(systemName: "person.circle")
    
    var dateOfBirth: Date?
    var age: Int?
    
    var meetingContext: String?
    var communicationAims: String?
    
    var notes: String?
    
    mutating func setTag(_ tag: Tag){
        self.tag = tag
    }
}
