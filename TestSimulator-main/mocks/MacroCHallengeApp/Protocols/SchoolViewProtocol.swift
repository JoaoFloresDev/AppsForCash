//
//  SchoolViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol SchoolViewProtocol {
    /**
     
     Método que inicializa a view de um colégio específico. Ele deve receber a escola que a view irá mostrar. Ele também deve
     receber o controlador da view.
     
     - parameter data: Um único colégio que será exibido.
     - parameter controller: Um controlador do tipo SchoolViewControllerProtocol
     
     */
    init(data: School, controller: SchoolViewControllerProtocol)
    
    // Dependências
    var viewController: SchoolViewControllerProtocol {get set}
}
