//
//  MetricsProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import Foundation

protocol MetricsProtocol {
    /**
     
     Método que retorna um objeto do tipo ResultsPerTopic que simboliza o desempenho do estudante no geral.
     
     - returns: Um objeto ResultsPerTopic que contém as métricas gerais.
     
     */
    func getGeneralResults() -> ResultsPerTopic
    
    /**
     
     Método que retorna todas as escolas contidas dentro da classe que implementa o protocolo Schools.
     
     - returns: Um array que contém todas as escolas.
     
     */
    func getTopicsResults() -> [String:ResultsPerTopic]
}
