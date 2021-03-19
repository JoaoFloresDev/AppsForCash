//
//  OverviewViewControllerImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 07/10/20.
//

import UIKit

class OverviewViewControllerImplementation: UIViewController, OverviewViewControllerProtocol {
	// MARK: - Constants
	// TODO: Ver como esse controller de fato obterá essa informação
	private let testDurationInSeconds = 10 * 60 // Valor de teste: Dez minutos

	// MARK: - Dependencies
	var myView: OverviewViewProtocol?
	var questionController: QuestionViewControllerProtocol?

	// MARK: - Private attributes
	private var data: Test
	private var questionsAnswered: [String:String] = [:]
	private(set) var totalPercentageOfCorrectAnswers: Double = 0.0
	private var timeText: String = "00:00"
	private var timer: Timer?

	// MARK: - Init methods
	required init(data: Test) {
		self.data = data
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle methods
	override func loadView() {
		super.loadView()
		setupDefaultView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupDefaultQuestionController()
		self.title = data.name
	}

	// MARK: - Setup methods
	private func setupDefaultView() {
		let defaultView = OverviewViewImplementation(data: self.data, controller: self)
		self.myView = defaultView
		self.view = defaultView
	}

	private func setupDefaultQuestionController() {
		let defaultQuestionController = QuestionViewControllerImplementation(data: data.questions, parentController: self)
		self.questionController = defaultQuestionController
	}

	// MARK: - OverviewViewControllerProtocol methods
	func questionWasSubmitted(_ question: Question) {
		guard let questionController = self.questionController else { return }
		guard let navController = self.navigationController else { return }

		questionController.displayQuestion(question)

		if let questionControllerAsUIViewController = questionController as? UIViewController {
			navController.pushViewController(questionControllerAsUIViewController, animated: true)
		}
	}

	func answerForQuestionWasSubmitted(question: Question, answer: String) {
		questionsAnswered[question.number] = answer
		updateView()
	}

	func questionWasUnsubmitted(question: Question) {
		questionsAnswered[question.number] = nil
		updateView()
	}

	func hasEnded() {
		DispatchQueue.main.async {
			self.timer?.invalidate()
		}
		if let navCon = self.navigationController, let questionController = self.questionController {
			let resultsVC = ResultsViewController(test: data, answeredQuestions: questionsAnswered, timeElapsed: timeText, questionController: questionController)
			navCon.pushViewController(resultsVC, animated: true)
		}
	}

	func hasBegun() {
		setClock()
	}

	// MARK: - Private methods

	/**

	Mapeia as chaves de um dicionário para um vetor de inteiros. Caso ele não consiga mapear a chave, o resultado é zero.

	- parameter dict O dicionário que será mapeado
	- returns Um vetor de inteiros com as chaves do dicionário como valores

	*/
	private func dictKeysAsIntArray(_ dict: [String:String]) -> [Int] {
		return Array(dict.keys).map { (value) -> Int in
			if let integerKey = Int(value) {
				return integerKey
			} else {
				return 0
			}
		}
	}

	/**

	Calcula o progresso feito (questões respondidas/questões totais) na forma de um Double arredondado que representa a porcentagem.

	- returns O valor arredondado do progresso em porcentagem (exemplo: 33.00)

	*/
	private func calculateProgress() -> Double {
		let doubleValue: Double =  Double(questionsAnswered.count) / Double(data.questions.count)
		return (doubleValue * 100).rounded()
	}

	/**

	Atualiza o view sobre o status de questões respondidas/não respondidas.

	*/
	private func updateView() {
		let questionsAnsweredNumbersSorted: [Int] = dictKeysAsIntArray(questionsAnswered).sorted()
		myView?.updateAnsweredQuestions(questionsAnswered: questionsAnsweredNumbersSorted)
		let progressAsPercentage = calculateProgress()
		myView?.updatePercentage(percentage: progressAsPercentage)
		myView?.updateCurrentQuestionsLabel(questionsAnswered: questionsAnswered.count)
	}

	/**

	Método responsável por gerir o tempo dedicado à uma prova. Ele é responsável por atualizar os elementos gráficos ligados ao tempo. Quando o tempo da prova acaba (definido pela constante
	testDurationInSeconds) é emitido um aviso sobre o ocorrido e o timer é invalidado.

	*/
	private func setClock() {
		var totalCounter = 0
		var minuteCounter = 0
		var minutes = 0
		var hours = 0

		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			totalCounter += 1
			minuteCounter += 1

			if minuteCounter == 60 {
				minutes += 1
				minuteCounter = 0

				if minutes == 60 {
					hours += 1
					minutes = 0
				}

				if minutes < 10 {
					DispatchQueue.main.async {
						self.timeText = String(format: "0%d", hours) + ":" + String(format: "0%d", minutes)
						self.myView?.updateTime(self.timeText)
						self.questionController?.updateTime(self.timeText)
					}
				} else {
					DispatchQueue.main.async {
						self.timeText = String(format: "0%d", hours) + ":" + String(format: "%d", minutes)
						self.myView?.updateTime(self.timeText)
						self.questionController?.updateTime(self.timeText)
					}
				}
			}

			if totalCounter == self.testDurationInSeconds {
				timer.invalidate()
				DispatchQueue.main.async {
					self.myView?.showTimeHasEndedAlert()
				}
			}
		}
	}
}
