//
//  OverviewViewProtocol.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 07/10/20.
//

import Foundation

protocol OverviewViewProtocol {
	/**

	Método que inicializa a view da visão geral da prova. Ele deve receber a prova que a view irá mostrar. Ele
	também recebe o controlador da view.


	- parameter data: A prova sendo realizada.
	- parameter controller: Um controlador do tipo OverviewControllerProtocol

	*/

	init(data: Test, controller: OverviewViewControllerProtocol)

	/**

	Método que atualiza o progresso mostrado na barra de progresso no overview.


	- parameter percentage: O progresso a ser mostrado.

	*/

	func updatePercentage(percentage: Double)

	/**

	Método que atualiza a label que contém o número de já questões feitas.


	- parameter questionsAnswered: Número de questões já feitas.

	*/

	func updateCurrentQuestionsLabel(questionsAnswered: Int)

	/**

	Método que indica visualmente no overview as questões respondidas.


	- parameter questionsAnswered: Um vetor de inteiros com os números das questões já respondidas.

	*/

	func updateAnsweredQuestions(questionsAnswered: [Int])

	/**

	Método que irá sinalizar a view para atualizar a sua label do cronômetro.

	- parameter newTimeText: O novo texto do cronômetro no formato HH:MM (exemplo 01:20)

	*/

	func updateTime(_ newTimeText: String)

	/**

	Método que irá sinalizar a view para mostrar o alerta de que o tempo acabou.

	*/

	func showTimeHasEndedAlert()

	// Dependências
	var viewController: OverviewViewControllerProtocol  {get set}
}
