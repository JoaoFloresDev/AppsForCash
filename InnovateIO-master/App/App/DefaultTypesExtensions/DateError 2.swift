//
//  DateError.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 23/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

enum DateError: Error {
    case calendarNotFound
    case emptyYear
    case emptyMonth
    case emptyDay
    case emptyHour
    case emptyMinute
    case emptySecond
}
