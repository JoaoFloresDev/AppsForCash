//
//  ResultsPerTopic.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 13/10/20.
//

import Foundation

struct ResultsPerTopic: Equatable {
    private(set) var totalPercentageOfCorrectAnswers: Double
    private(set) var totalNumberOfCorrectAnswers: Int
    private(set) var totalNumberOfAnsweredQuestions: Int
    private(set) var totalNumberOfQuestions: Int
    init(totalPercentageOfCorrectAnswers: Double, totalNumberOfCorrectAnswers: Int,
         totalNumberOfAnsweredQuestions: Int, totalNumberOfQuestions: Int ) {
        self.totalPercentageOfCorrectAnswers = totalPercentageOfCorrectAnswers
        self.totalNumberOfCorrectAnswers = totalNumberOfCorrectAnswers
        self.totalNumberOfAnsweredQuestions = totalNumberOfAnsweredQuestions
        self.totalNumberOfQuestions = totalNumberOfQuestions
    }
}
