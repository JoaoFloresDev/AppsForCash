//
//  HistoricViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 28/10/20.
//

import Foundation

protocol HistoricViewProtocol {
	/**

	Método que inicializa as views das provas. Ele deve receber as escolas que a view irá mostrar com suas provas respectivas. Além disso, ele
	recebe o controller da view.

	- parameter data: Um array de objetos School.
	- parameter viewController: Um controlador do tipo HistoricViewControllerProtocol.

	*/
	init(data: [School], controller: HistoricViewControllerProtocol)

	// Dependências
	var viewController: HistoricViewControllerProtocol {get set}
}
