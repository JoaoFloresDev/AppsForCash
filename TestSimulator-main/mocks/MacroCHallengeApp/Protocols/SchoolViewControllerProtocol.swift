//
//  SchoolViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol SchoolViewControllerProtocol {
    /**
     
     Método que inicializa o controller para um colégio específico.
     
     - parameter data: Escola cujo os dados serão mostrados.
     
     */
    init(data: School)
    
    /**
     
     Método que recebe um objeto Test e a partir dele será responsável de chamar o controller que iniciará o simulado com a prova fornecida.
     
     - parameter test: prova selecionada pela View.
     
     */
    func testWasSubmitted(_ test: Test)
    
    /**
     
     Método que recebe um um dicionário [String:String] que representa o edital de um colégio. Ele será responsável por chamar o controller que mostrará o edital.
     
     - parameter notice :  edital selecionado pela View.
     
     */
    func noticeWasSubmitted(_ notice: Notice)
    
    // Dependências
    var myView: SchoolViewProtocol? {get set}
}
