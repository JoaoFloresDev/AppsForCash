//
//  SchoolsViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import UIKit
import SwiftyJSON

class SchoolsViewControllerImplementation: UIViewController, SchoolsViewControllerProtocol {
	// MARK: - Dependencies
	/*

	Nota: como este View Controller é o primeiro a ser instanciado no Storyboard, ele é o único que possuirá
	dependências opcionais que não são a sua view. Para contornarmos isso, existem métodos de setup que são responsáveis
	por popular essas variáveis com suas implementações padrões. Para os demais controllers, as implementações padrões de
	suas dependências (exceto pela view) são passadas em seu inicializador (veja o método schoolWasSubmitted, por exemplo).

	*/
	var myView: SchoolsViewProtocol?
	var schools: SchoolsProtocol?

	// MARK: - Lifecycle methods
	override func loadView() {
		super.loadView()
		setupDefaultSchoolsImplementation()
		setupDefaultViewImplementation()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Colégios"
	}

	// MARK: - Setup methods
	private func setupDefaultSchoolsImplementation() {
		self.schools = MockSchoolsImplementation()
	}

	private func setupDefaultViewImplementation() {
		if let data = schools?.getSchools() {
			let defaultView = SchoolsViewImplementation(data: data, controller: self)
			self.myView = defaultView
			self.view = defaultView
		}
	}

	// MARK: - SchoolViewControllerProtocol methods
	func schoolWasSubmitted(_ school: School) {
		print("------------------")
		print("clicou na prova")
		if let navController = self.navigationController {
			let schoolViewController = SchoolViewControllerImplementation(data: school)
			navController.pushViewController(schoolViewController, animated: true)
		}
	}
}

