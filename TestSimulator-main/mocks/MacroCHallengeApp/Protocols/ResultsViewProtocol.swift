//
//  ResultsViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 13/10/20.
//

import Foundation

protocol ResultsViewProtocol {
    /**
     
     Método responsável por inicializar a view dos resultados (dos gráficos e afins).  Ela é inicializada com o container chamado ResultsData. Veja a classe modelo.
     
     - parameter data: Um container do tipo ResultsData. Ele contém TODA a informação necessária para a população dos elementos da view.
     - parameter viewController: Um controlador do tipo ResultsViewController
     
     */
    init(data: ResultsData, viewController: ResultsViewControllerProtocol)
    
    // Dependências
    var viewController: ResultsViewControllerProtocol {get set}
}
