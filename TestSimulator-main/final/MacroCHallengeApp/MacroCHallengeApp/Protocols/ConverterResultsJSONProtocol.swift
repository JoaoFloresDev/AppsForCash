//
//  ConverterResultsJSONProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 30/10/20.
//

import SwiftyJSON
import Foundation

protocol ConverterResultsJSONProtocol {
    /**
    Função responsável por converter um objeto JSON em um objeto da classe ResultsPerTopic que representa métricas gerais.

    - parameter json: Objeto JSON com dados de resultados gerais e resultados por métricas a ser convertida para objeto ResultsPerTopic .

    */
    func createResultPerTopic(json: JSON) throws -> ResultsPerTopic

    /**
    Função responsável por converter um objeto JSON em um dicionário do tipo [String:ResultPerTopic] que representa as métricas por matéria. Essa função utilizará a função createResultPerTopic em sua implementação interna.

    - parameter json: Objeto JSON com dados de resultados gerais e resultados por métricas a ser convertida para um dicionário [String:ResultPerTopic].

    */
    func createDictionaryTopicsResults(json: JSON) throws -> [String:ResultsPerTopic]
}
