//
//  NoticeViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 22/10/20.
//

import Foundation

protocol NoticeViewProtocol {
    /**
     
     Método que inicializa a view de um edital específico. Ele deve receber um dicionário contendo as informações que a view irá mostrar. Ele também deve receber o controlador da view.
     
     - parameter notice: objeto notice contendo as informações de um edital de uma escola que serão exibidas na view.
     - parameter controller: Um controlador do tipo NoticeViewControllerProtocol
     
     */
    init(notice: Notice, controller: NoticeViewControllerProtocol)
    
    // Dependências
    var viewController: NoticeViewControllerProtocol {get set}
}
