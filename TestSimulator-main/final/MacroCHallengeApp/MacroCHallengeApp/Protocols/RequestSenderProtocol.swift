//
//  RequestSender.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 26/10/20.
//

import Foundation

protocol RequestSenderProtocol {
    func getQuestionsForTestRequest(testName: String, testYear: String, completion: @escaping ([Question]?, String?) -> Void)
}
