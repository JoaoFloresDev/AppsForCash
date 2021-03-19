//
//  Test.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 05/10/20.
//

import Foundation

class Test {
    private(set) var name: String
    private(set) var year: String
    private(set) var questions: [Question]
    
    init(name: String, year: String, questions: [Question]) {
        self.name = name
        self.year = year
        self.questions = questions
    }
}
