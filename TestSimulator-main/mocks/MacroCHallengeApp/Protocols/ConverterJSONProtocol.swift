//
//  ConverterJSONProtocol.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 27/10/20.
//

import SwiftyJSON
import Foundation

protocol ConverterJSONProtocol {
	/**
	Função responsável por converter um objeto JSON em um objeto da  classe Question

	- parameter json: Objeto JSON com dados da questão a ser convertida para objeto Question

	Como usar:

	do {
	let converterJSON = try ConverterJSON().createQuestion(json: json)
	print(converterJSON)
	}
	catch let error as UserValidationError {
	print(error.rawValue)
	} catch {
	print("Unspecific Error")
	}

	*/
	func createQuestion(json: JSON) throws -> Question

}
