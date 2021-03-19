//
//  School.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 05/10/20.
//

import Foundation
import UIKit

class School {
    private(set) var name: String
    private(set) var location: [String]
    private(set) var logo: UIImage
    private(set) var notice: Notice
    private(set) var tests: [Test]
    
    init(name: String, location: [String], logo: UIImage, notice: Notice, tests: [Test]) {
        self.name = name
        self.location = location
        self.logo = logo
        self.notice = notice
        self.tests = tests
    }
}
