//
//  String+.swift
//  App
//
//  Created by Priscila Zucato on 12/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {

        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
