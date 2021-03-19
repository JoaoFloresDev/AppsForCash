//
//  NoticeInfoViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 26/10/20.
//

import Foundation

protocol NoticeInfoViewControllerProtocol {
    /**
     
     Método que inicializa o controller para tela de informações após o usuário clicar em um item do edital.
     
     - parameter topic: um vetor com o que cai em um determinado tópico
     - parameter numberOfQuestions: número de questões de um tópico
     - parameter nameOfThetopic: nome de um tópico
     - parameter essay: um dicionário com as informações da redação
     
     */
    
    init(_ topic: [String]?, _ numberOfQuestions: Int?, _ nameOfThetopic: String?, _ essay: [String : String]?)
        
    // Dependências
    var myView: NoticeInfoViewProtocol? {get set}
}
