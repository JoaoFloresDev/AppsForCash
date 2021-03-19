//
//  QuestionViewController.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 05/10/20.
//

import Foundation

protocol QuestionViewControllerProtocol {
	/**

	Método que inicializa o controller para uma prova específica. Ele deve receber todas as questões da prova. Além disso, deve recebe o controlador "pai" na
	hierarquia de informação.

	- parameter data: As questões da prova.
	- parameter parentController: O controlador pai na hierarquia.

	*/

	init(data: [Question], parentController: OverviewViewControllerProtocol)

	/**

	Método que alerta o controller que o botão “próximo” foi pressionado. Este método deve conter a lógica para, a partir dele, a próxima questão ser exibida na view.

	*/

	func nextWasSubmitted()

	/**

	Método que alerta o controller que o botão “anterior” foi pressionado. Este método deve conter a lógica para, a partir dele, a questão anterior ser exibida na view.

	*/

	func previousWasSubmitted()

	/**

	Método que alerta o controller que ele deve exibir uma questão em específico. Ao ser chamado, o controlador deve fazer a lógica para que os apontadores de previous e next fiquem
	nas posições corretas.

	- parameter question: Questão que deve ser exibida.

	*/

	func displayQuestion(_ question: Question)


	/**

	Método pelo qual a view avisa o controlador que uma alternativa foi selecionada.

	- parameter question: Questão para a qual a resposta foi selecionada.
	- parameter answer: Resposta selecionada.

	*/

	func answerWasSubmitted(question: Question, answer: String)

	/**

	Método pelo qual a view avisa o controlador que uma alternativa deselecionada como resposta.

	- parameter question: Questão para a qual a resposta foi deselecionada.

	*/

	func answerWasUnsubmitted(question: Question)

	/**

	Método que irá sinalizar a view para atualizar a sua label do cronômetro.

	- parameter newTimeText: O novo texto do cronômetro no formato HH:MM (exemplo 01:20)

	*/

	func updateTime(_ newTimeText: String)


	/**

	Variável de controle que indica se o controlador deve ou não mostrar a resposta da questão.

	*/

	var shouldDisplayAnswer: Bool {get set}

	// Dependências
	var myView: QuestionViewProtocol? {get set}
	var parentController: OverviewViewControllerProtocol {get set}
}
