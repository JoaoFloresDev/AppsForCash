//
//  ResultsViewController.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 13/10/20.
//

import Foundation

protocol ResultsViewControllerProtocol {
    /**
     
     Método responsável por inicializar o controlador com os dados necessários para que ele realize os cálculos em cima
     dos resultados obtidos pelo usuário ao final de uma prova.
     
     - parameter Test: A prova realizada.
     - parameter answeredQuestions: As repostas fornecidas pelo usuário ao finalizar a prova.
     - parameter timeElapsed: Uma string com o tempo total que o usuário gastou na prova no formato HH:MM
     - parameter questionController: O controlador de exibição de questões.
     
     */
    init(test: Test, answeredQuestions: [String : String], timeElapsed:String,
         questionController: QuestionViewControllerProtocol)
    
    /**
     
     Método pelo qual a view avisa o controller que uma questão foi selecionada.
     
     
     - parameter question: A questão selecionada.
     
     */
    
    func questionWasSubmitted(_ question: Question)
    
    // Dependências
    var myView: ResultsViewProtocol? {get set}
}
