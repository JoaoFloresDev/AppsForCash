//
//  ResultsData.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 13/10/20.
//

import Foundation

class ResultsData {
    private(set) var totalPercentageOfCorrectAnswers: Double
    private(set) var totalNumberOfCorrectAnswers: Int
    private(set) var totalNumberOfAnsweredQuestions: Int
    private(set) var totalNumberOfQuestions: Int
    private(set) var resultsPerTopic: [String: ResultsPerTopic]
    private(set) var test: Test
    private(set) var answeredQuestions: [String : String]
    private(set) var totalTimeElapsed: String
    private(set) var correctAnswers: [Int]
    private(set) var wrongAnswers: [Int]
    
    init(totalPercentageOfCorrectAnswers: Double, totalNumberOfCorrectAnswers: Int,
         totalNumberOfAnsweredQuestions: Int, totalNumberOfQuestions: Int,
         resultsPerTopic: [String: ResultsPerTopic], test: Test,
         answeredQuestions: [String: String], totalTimeElapsed: String,
         correctAnswers: [Int], wrongAnswers: [Int]) {
        self.totalPercentageOfCorrectAnswers = totalPercentageOfCorrectAnswers
        self.totalNumberOfCorrectAnswers = totalNumberOfCorrectAnswers
        self.totalNumberOfAnsweredQuestions = totalNumberOfAnsweredQuestions
        self.totalNumberOfQuestions = totalNumberOfQuestions
        self.resultsPerTopic = resultsPerTopic
        self.test = test
        self.answeredQuestions = answeredQuestions
        self.totalTimeElapsed = totalTimeElapsed
        self.correctAnswers = correctAnswers
        self.wrongAnswers = wrongAnswers
    }
}
