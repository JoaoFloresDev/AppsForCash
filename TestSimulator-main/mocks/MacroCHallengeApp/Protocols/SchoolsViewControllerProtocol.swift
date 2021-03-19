//
//  SchoolsViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol SchoolsViewControllerProtocol {
    /**
     
     Método que recebe um objeto School da view e a partir dele, é responsável de chamar o próximo controller responsável por exibir dados de um colégio específico
     
     - parameter school: Escola selecionada pela View.
     
     */
    func schoolWasSubmitted(_ school: School)
    
    // Dependências
    var myView: SchoolsViewProtocol? {get set}
    var schools: SchoolsProtocol? {get set}
}
