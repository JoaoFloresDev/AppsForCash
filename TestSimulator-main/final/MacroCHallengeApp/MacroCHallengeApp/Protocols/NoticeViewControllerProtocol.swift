//
//  NoticeViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 22/10/20.
//

import Foundation

protocol NoticeViewControllerProtocol {
    /**
     
     Método que inicializa o controller para um edital específico.
     
     - parameter data: Dicionário cujo os dados serão mostrados.
     
     */
    init(data: Notice)
    
    /**
     
     Método que recebe um dicionário que contem o número de questões e o conteúdo programático e a partir dele será responsável de chamar o controller que mostrará as informações do tópico selecionado.
     
     - parameter topic: array contendo informações do tópico selecionado pela View.
     - parameter numberOfQuestions: número de questões do tópico selecionado pela View.
    
     
     */
    func topicWasSubmitted(_ topic: [String], _ numberOfQuestions: Int, _ nameOfThetopic: String)
    
    /**
     
     Método que recebe um dicionário que contem informações da redação de uma prova (e.g, tema, estrutura, expressão) e a partir dele será responsável de chamar o controller que mostrará as informações da redação.
     
     - parameter essay: dicionário contendo informações da redação selecionada pela View.
     
     */
    func essayWasSubmitted(_ essay: [String:String])
    
    /**
     
     Método que recebe um uma String que representa a URL do link para o edital de um colégio. Ele será responsável por abrir o link que mostrará o edital no próprio site da instituição.
     
     - parameter linkNotice: link do edital para abrir em um browser.
     
     */
    func moreInformationWasSubmitted(_ linkNotice: String)
    
    // Dependências
    var myView: NoticeViewProtocol? {get set}
}
