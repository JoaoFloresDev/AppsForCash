//
//  HistoricViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 27/10/20.
//

import Foundation

protocol HistoricViewControllerProtocol {
	/**

	Método que recebe um objeto Test da view e a partir dele, é responsável de chamar o próximo controller responsável por exibir dados de uma prova específico

	- parameter school: Prova selecionada pela View.

	*/
	func testWasSubmitted(_ test: Test)

	// Dependências
	var myHistoricView: HistoricViewProtocol? {get set}
	var schools: SchoolsProtocol? {get set}
}
