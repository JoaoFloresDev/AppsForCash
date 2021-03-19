//
//  OverviewViewImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 07/10/20.
//

import UIKit

class OverviewViewImplementation: UIView, OverviewViewProtocol {
	// MARK: - Private attributes
	private var data: Test
	private var answeredQuestionsArray = [Int]()
	private var simulatorStarted = false

	/**

	Um dicionário que contém como chaves as matérias da prova e como valor tem uma tupla cujo o primeiro elemento representa a seção da chave e o segundo representa o número de questões daquela chave.
	*/

	private var sectionDictionary: [String:(Int, Int)] = [:]

	// MARK: -IBOutlets
	@IBOutlet weak var questionsView: UIView!
	@IBOutlet weak var questionsCollege: UICollectionView!
	@IBOutlet var clockLabel: UILabel!
	@IBOutlet weak var progressChart: HorizontalChartView!

	// MARK: - Dependencies
	var viewController: OverviewViewControllerProtocol

	// MARK: - Init methods
	required init(data: Test, controller: OverviewViewControllerProtocol) {
		self.data = data
		self.viewController = controller
		super.init(frame: CGRect.zero)
		initFromNib()
		setupSectionDictionary()
		setupVisualElements()
		setupDelegateCollectionview()

		progressChart.setup(title: "Progresso", correctQuestions: 00, totalQuestions: data.questions.count)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initFromNib() {
		if let nib = Bundle.main.loadNibNamed("OverviewViewImplementation", owner: self, options: nil),
		   let nibView = nib.first as? UIView {
			nibView.frame = bounds
			nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			addSubview(nibView)
		}
	}

	// MARK: - OverviewViewProtocol methods
	func updatePercentage(percentage: Double) {
		progressChart.updatePercentage(percentage: percentage)
	}

	func updateCurrentQuestionsLabel(questionsAnswered: Int) {
		progressChart.updateCurrentQuestionsLabel(questionsAnswered: questionsAnswered, totalQuestions: data.questions.count)
	}

	func updateAnsweredQuestions(questionsAnswered: [Int]) {
		answeredQuestionsArray = questionsAnswered
		questionsCollege.reloadData()
	}

	func updateTime(_ newTimeText: String) {
		self.clockLabel.text = newTimeText
	}

	func showTimeHasEndedAlert() {
		showAlert(title: "O tempo para o simulado acabou", msg: "O tempo dedicado à prova acabou. Mesmo assim, você ainda pode finalizar as suas questões.", shouldPresentCancel: false, closure: ({action in}))
	}

	// MARK: - Private methods

	/**

	Método que apresenta alertas na view.

	- parameter title: Título do alerta
	- parameter msg: Mensagem do alerta
	- parameter shouldPresentCancel: Booleano que indica se o alarme deve mostrar o botão "cancelar"'
	- parameter closure: Função executada ao ser pressionada a opção "ok"

	*/
	private func showAlert(title: String, msg: String, shouldPresentCancel: Bool, closure: @escaping (UIAlertAction) -> Void) {
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

		if shouldPresentCancel {
			alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
		}

		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: closure))

		if let viewController = self.viewController as? UIViewController {
			viewController.present(alert, animated: true, completion: nil)
		}

	}

	/**

	Método responsável, a partir da propriedade self.data, popular os elementos visuais da view.

	*/
	private func setupVisualElements() {
		if let viewController = self.viewController as? UIViewController {
			viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Iniciar Prova", style: .plain, target: self, action: #selector(StartOrFinishNavButtonTapped))
		}

		updatePercentage(percentage: 0.0)
		updateCurrentQuestionsLabel(questionsAnswered: 0)
	}

	/**

	Método responsável de montar o array de seções a partir das questões da prova.

	*/
	private func setupSectionDictionaryKeys() -> [String]{
		var resultArray: [String] = []

		for question in data.questions {
			if !resultArray.contains(question.topic) {
				resultArray.append(question.topic)
			}
		}

		return resultArray
	}

	/**

	Método que nos retorna o número de questões de um determinado tópico.

	- parameter topic: Tópico de uma prova.

	*/
	private func countingQuestionsForTopic(_ topic: String) -> Int {
		var result: Int = 0

		for question in data.questions {
			if question.topic == topic {
				result += 1
			}
		}

		return result
	}

	/**

	Método que monta o dicionário de seções, onde a chave é a seção e o valor é uma tupla. O primeiro valor da tupla é o número da seção que ela representa na Collection View e o segundo valor da tupla representa o número de questões dentro dessa seção.

	*/
	private func setupSectionDictionary() {
		let dictionaryKeys: [String] = setupSectionDictionaryKeys()
		var index = 0

		for key in dictionaryKeys {
			sectionDictionary[key] = (index , countingQuestionsForTopic(key))
			index += 1
		}
	}

	/**

	Método que retorna o número da questão dentro de uma seção para que a OverView tenha questões do 1, 2,..., {número total de questões da prova}.

	*/
	private func giveCorrectQuestionNumberForIndexPath(section: Int) -> Int{
		var jumpAmount: Int = 0

		for (_, value) in sectionDictionary {
			if value.0 < section {
				jumpAmount += value.1
			}
		}

		return jumpAmount
	}

	private func getNameOfSection(section: Int) -> String{

		for (key, value) in sectionDictionary {
			if section == value.0 {
				return key
			}
		}

		return ""
	}
	/**

	Função executada quando o botão de começar/finalizar o simulado é pressionado.

	*/
	@objc private func StartOrFinishNavButtonTapped() {
		if simulatorStarted {
			showAlert(title: "Deseja finalizar simulado?", msg: "Sua prova será finalizada e a nota calculada", shouldPresentCancel: true, closure: ({ action in
				self.simulatorStarted = false
				self.viewController.hasEnded()
				if let viewController = self.viewController as? UIViewController {
					viewController.navigationItem.rightBarButtonItem?.title = "Iniciar"
				}
			}))
		} else {
			self.simulatorStarted = true
			self.viewController.hasBegun()
			self.viewController.questionWasSubmitted(data.questions[0])
			if let viewController = self.viewController as? UIViewController {
				viewController.navigationItem.rightBarButtonItem?.title = "Finalizar"
			}
		}
	}
}

// MARK: - Extension Table View Data Source Methods
extension OverviewViewImplementation:UICollectionViewDataSource, UICollectionViewDelegate {

	func setupDelegateCollectionview() {
		questionsCollege.delegate = self
		questionsCollege.dataSource = self
		questionsCollege.register(UINib(nibName: "OverviewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OverviewCollectionCell")
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		var numberOfItemsInSection = 0
		let dictionaryKeysAsArray = Array(sectionDictionary.keys).sorted()

		for index in 0...(dictionaryKeysAsArray.count - 1) {
			let key = dictionaryKeysAsArray[index]
			guard let tupleValue = sectionDictionary[key] else {
				return 0
			}

			if tupleValue.0 == section {
				numberOfItemsInSection = tupleValue.1
			}
		}

		return numberOfItemsInSection
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = questionsCollege.dequeueReusableCell(withReuseIdentifier: "OverviewCollectionCell", for: indexPath) as! OverviewCollectionCell
		let indexFix = giveCorrectQuestionNumberForIndexPath(section: indexPath.section)
		cell.numberLabel.text = data.questions[indexFix + indexPath.row].number

		if let questionNumber = Int(data.questions[indexFix + indexPath.row].number) {
			if answeredQuestionsArray.contains(questionNumber) {
				cell.bgView.backgroundColor = UIColor(red:25/255, green:95/255, blue:230/255, alpha: 1)
				cell.bgView.layer.borderColor = UIColor(red:25/255, green:95/255, blue:230/255, alpha: 1).cgColor
				cell.numberLabel.textColor = UIColor.white
			} else {
				cell.bgView.backgroundColor = UIColor.white
				cell.numberLabel.textColor = UIColor(red:25/255, green:95/255, blue:230/255, alpha: 1)
			}
		}

		return cell
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sectionDictionary.count
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let indexFix = giveCorrectQuestionNumberForIndexPath(section: indexPath.section)
		if simulatorStarted {
			viewController.questionWasSubmitted(data.questions[indexFix + indexPath.row])
		} else {
			self.showAlert(title: "Iniciar novo simulado?", msg: "Para acessar as questões comece um novo simulado", shouldPresentCancel: true, closure: ({ action in
				self.viewController.hasBegun()
				self.simulatorStarted = true
				self.viewController.hasBegun()
				self.viewController.questionWasSubmitted(self.data.questions[indexFix + indexPath.row])
				if let viewController = self.viewController as? UIViewController {
					viewController.navigationItem.rightBarButtonItem?.title = "Finalizar"
				}
			}))
		}
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			questionsCollege.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
									  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
									  withReuseIdentifier: "HeaderCollectionReusableView")

			if let headerView = questionsCollege.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as? HeaderCollectionReusableView {
				headerView.topicLabel.text = getNameOfSection(section: indexPath.section)
				return headerView
			}
		}
		return UICollectionReusableView()
	}
}
