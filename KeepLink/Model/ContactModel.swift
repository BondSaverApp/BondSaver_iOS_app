//
//  ContactModel.swift
//  KeepLink
//
//  Created by Андрей Степанов on 06.12.2024.
//

import Foundation

struct Contact{
    var name: String
    var surname: String?
    var secondName: String?
    
    let dateOfBirth: Date?
    var age: Int?
    
    var meetingContext: String?
    var communicationAims: String?
    
    var notes: String?
}
