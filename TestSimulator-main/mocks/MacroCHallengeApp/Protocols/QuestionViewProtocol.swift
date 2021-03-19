//
//  QuestionView.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol QuestionViewProtocol {
  
    
    // MARK: Funções
    
    /// Método que inicializa a view de uma questão específica. Ela deve receber a questão que a view irá mostrar. Ele também recebe o controlador da view
    /// - parameter data: Uma única questão que será exibida
    /// - parameter controller: Um controlador do tipo QuestionViewControllerProtocol
    /// - parameter shouldPresentAnswer: Booleano que dita se a resposta correta deve ser exibida ou não. Mostrar as respostas desabilita a  seleção de uma nova resposta
    /// - parameter numberOfQuestions: Número de questões da prova para controlar a exibição dos botões que navegam entre as questões
    init(data: Question, controller: QuestionViewControllerProtocol, wasAlreadyAnswered: String?, shouldPresentAnswer: Bool, numberOfQuestions: Int)
    
    /// Método que irá sobrescrever os elementos visuais da questão atual com a questão fornecida
    /// - parameter data: A questão que agora será exibida
    /// - parameter wasAlreadyAnswered: String opcional para indicar se uma questão já foi ou não respondida. Caso seu valor não seja nil, quer dizer que a questão já foi respondida
    /// - parameter shouldPresentAnswer: Booleano que dita se a resposta correta deve ser exibida ou não. Mostrar as respostas desabilita a  seleção de uma nova resposta
    func overwrite(data: Question, wasAlreadyAnswered: String?, shouldPresentAnswer: Bool)

    /// Método que irá sinalizar a view para atualizar a sua label do cronômetro
    /// - parameter newTimeText: O novo texto do cronômetro no formato HH:MM (exemplo 01:20)
    func updateTime(_ newTimeText: String)
    
    
    // MARK: Dependências
    
    var controller: QuestionViewControllerProtocol {get set}
}
