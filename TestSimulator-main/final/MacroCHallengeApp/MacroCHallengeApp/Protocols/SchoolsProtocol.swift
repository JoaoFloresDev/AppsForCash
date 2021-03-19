//
//  SchoolsProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol SchoolsProtocol {
	/**

	Método que retorna todas as escolas contidas dentro da classe que implementa o protocolo Schools.
	
	- returns: Um array que contém todas as escolas.

	*/
	func getSchools() -> [School]
}
