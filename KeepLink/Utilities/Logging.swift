//
//  Logging.swift
//  KeepLink
//
//  Created by Maria Mayorova on 19.04.2025.
//

import Foundation

typealias Logging = (String) -> Void

let emptyLogging: Logging = { _ in }

let printLogging: Logging = { message in
    #if DEBUG
        print(message)
    #endif
}
