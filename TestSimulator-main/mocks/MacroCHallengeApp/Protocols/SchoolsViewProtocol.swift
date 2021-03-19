//
//  SchoolsViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol SchoolsViewProtocol {
    /**
     
     Método que inicializa as views dos colégios. Ele deve receber as escolas que a view irá mostrar. Além disso, ele
     recebe o controller da view.
     
     - parameter data: Um array de objetos School.
     - parameter viewController: Um controlador do tipo SchoolsViewControllerProtocol.
     
     */
    init(data: [School], controller: SchoolsViewControllerProtocol)
    
    // Dependências
    var viewController: SchoolsViewControllerProtocol {get set}
}
