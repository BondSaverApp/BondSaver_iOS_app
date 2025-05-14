//
//  DataBase.swift
//  KeepLink
//
//  Created by Андрей Степанов on 10.03.2025.
//

import Foundation
import RealmSwift
import SwiftUI

final class DataBase {
    static let shared = DataBase()

    @ObservedResults(Contact.self) var contacts
    @ObservedResults(Meeting.self) var meetings
}
