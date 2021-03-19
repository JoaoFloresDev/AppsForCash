//
//  NoticeInfoViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 26/10/20.
//

import Foundation

protocol NoticeInfoViewProtocol {
    /**
     
     Método que inicializa a view de informações de um determidado dado de um edital (exemplos: pode clicar no tópico de História ou clicar para ver informações da redação). Ele pode receber duas coisas: um array de máterias com o número de questões OU dicionário contendo informações da redação.
     
     - parameter topic: um vetor com o que cai em um determinado tópico
     - parameter numberOfQuestions: número de questões de um tópico
     - parameter essay: um dicionário com as informações da redação
     - parameter controller: Um controlador do tipo NoticeInfoViewControllerProtocol
     
     */
    init(_ topic: [String]?, _ numberOfQuestions: Int?,_ nameOfThetopic: String?, _ essay: [String : String]?, controller: NoticeInfoViewControllerProtocol)
    
    // Dependências
    var viewController: NoticeInfoViewControllerProtocol {get set}
}
