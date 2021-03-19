//
//  ServiceErrors.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 07/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

enum PersistenceError: Error {
    case applicationNotRunning
    case dataNotFound
    case invalidDate
    case invalidTime
    case invalidEntity
    case cantSave
    case cantLoad
}
