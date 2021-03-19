//
//  MockMetricsImplementation.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import Foundation
import UIKit

class MockMetricsImplementation: MetricsProtocol {
    // MARK: - SchoolsProtocol methods
    func getGeneralResults() -> ResultsPerTopic {
        return hardGeneralResults()
    }
    
    func getTopicsResults() -> [String : ResultsPerTopic] {
        return hardTopicsResults()
    }
    
    /**
     
     Método que retorna uma métrica geral a partir do hardcoding.
     
     - returns: Um objeto do tipo ResultsPerTopic hardcoded para uma métrica geral.
     
     */
    
    private func hardGeneralResults() -> ResultsPerTopic {
        let result = ResultsPerTopic(totalPercentageOfCorrectAnswers: 68,
                                     totalNumberOfCorrectAnswers: 137,
                                     totalNumberOfAnsweredQuestions: 187,
                                     totalNumberOfQuestions: 200)
        return result
    }
    
    /**
     
     Método que retorna ResultsPerTopic de um determinado tópico.
     
     - returns: Um dicionário que contém como chave o tópico e seu respectivo resultado.
     
     */
    
    private func hardTopicsResults() -> [String : ResultsPerTopic] {
        let portuguese = ResultsPerTopic(totalPercentageOfCorrectAnswers: 77,
                                     totalNumberOfCorrectAnswers: 37,
                                     totalNumberOfAnsweredQuestions: 48,
                                     totalNumberOfQuestions: 50)
        
        let math = ResultsPerTopic(totalPercentageOfCorrectAnswers: 50,
                                     totalNumberOfCorrectAnswers: 25,
                                     totalNumberOfAnsweredQuestions: 40,
                                     totalNumberOfQuestions: 50)
        
        let result = ["Português": portuguese,
                      "Matemática": math]
        
        return result
    }
    
}
