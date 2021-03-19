//
//  Notice.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 22/10/20.
//

import Foundation

class Notice {
    private(set) var topics: [String:[String]]
    private(set) var numberOfQuestionsPerTopic: [String:Int]
    private(set) var essay: [String:String]
    private(set) var linkNotice: String
    private(set) var durationTime: String
    

    init(topics: [String:[String]], numberOfQuestionsPerTopic: [String:Int], essay: [String:String], linkNotice: String, durationTime: String) {
        self.topics = topics
        self.numberOfQuestionsPerTopic = numberOfQuestionsPerTopic
        self.essay = essay
        self.linkNotice = linkNotice
        self.durationTime = durationTime
    }
}
