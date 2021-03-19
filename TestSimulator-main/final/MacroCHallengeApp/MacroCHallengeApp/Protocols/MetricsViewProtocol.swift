//
//  MetricsViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import Foundation

protocol MetricsViewProtocol {
    /**
     
     Método que inicializa as views das métricas. Ele deve receber as métricas que a view irá mostrar e as provas realizadas (métricas gerais e métricas por matérias). Além disso, ele recebe o controller da view.
     
     - parameter generalResults: Um objeto do tipo resultadoPerTopic que simboliza o desempenho geral do estudante
     - parameter topicsResults: Um objeto do tipo resultadoPerTopic que simboliza o desempenho geral do estudante
     - parameter viewController: Um controlador do tipo MetricsViewControllerProtocol.
     
     */
    init(generalResults: ResultsPerTopic, topicsResults: [String:ResultsPerTopic], controller: MetricsViewControllerProtocol)
    
    // Dependências
    var viewController: MetricsViewControllerProtocol {get set}
}
