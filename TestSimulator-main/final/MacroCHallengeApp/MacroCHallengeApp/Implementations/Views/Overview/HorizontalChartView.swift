//
//  HorizontalChartView.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 13/10/20.
//

import UIKit

class HorizontalChartView: UIView {
	// MARK: -IBOutlets
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var performanceLabel: UILabel!
	@IBOutlet weak var performanceBarView: UIView!

	// MARK: - Private methods
	/**
	Método responsável por definir qualidades visuais (sombra, corner radius) da célula.
	*/

	private func setupLabels(title: String, correctQuestions: Int, totalQuestions: Int) {
		titleLabel.text = title
		performanceLabel.text = String(correctQuestions) + "/" + String(totalQuestions)
	}

	private func setupPerformanceBar(correctQuestions: Int, totalQuestions: Int, percentage: Double) {
		performanceBarView.layer.cornerRadius = performanceBarView.frame.height/2
		updatePercentage(percentage: percentage)
	}

	// MARK: - Public methods
	/**
	Método responsável por update do estado de progresso
	*/

	func setup(title: String, correctQuestions: Int, totalQuestions: Int) {

		setupLabels(title: title, correctQuestions: correctQuestions, totalQuestions: totalQuestions)
		setupPerformanceBar(correctQuestions: correctQuestions, totalQuestions: totalQuestions, percentage: 0)
	}

	func updatePercentage(percentage: Double) {

		let currentProgress = UIView()
		for view in performanceBarView.subviews { // Limpa subviews anteriores
			view.removeFromSuperview()
		}
		currentProgress.backgroundColor = UIColor(named: "PrimaryGraphicsColor")

		if(percentage == 0) {
			currentProgress.frame = CGRect(x: 0, y: 0, width: performanceBarView.frame.height, height: performanceBarView.frame.height)
		} else {
			currentProgress.frame = CGRect(x: 0, y: 0, width: performanceBarView.frame.width*CGFloat(percentage)*0.01, height: performanceBarView.frame.height)
		}

		currentProgress.layer.cornerRadius = performanceBarView.frame.height/2
		performanceBarView.addSubview(currentProgress)
	}

	func updateCurrentQuestionsLabel(questionsAnswered: Int, totalQuestions: Int) {
		performanceLabel.text = String(format: "%02d", questionsAnswered) + "/" + String(format: "%02d", totalQuestions)
	}
}
