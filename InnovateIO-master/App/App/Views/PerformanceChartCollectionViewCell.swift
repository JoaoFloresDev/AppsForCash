//
//  PerformanceChartCollectionViewCell.swift
//  App
//
//  Created by Pietro Pugliesi on 07/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class PerformanceChartCollectionViewCell: UICollectionViewCell {

	@IBOutlet var separatorLineView: UIView!
	
	@IBOutlet var stackView: UIStackView!
	
	var timeDots = [PerformanceChartDotView]()
	private var dataHandler: DataHandler?

	func makeBlankTimeDots(){
		//make all dissappear
		for i in 0..<timeDots.count{
			timeDots[i].deactivate()
		}
	}
	
	func setupTimDotsFromStack(){
		for i in stackView.arrangedSubviews{
			var dot = i as! PerformanceChartDotView
			timeDots.append(dot)
		}
	}
	
	func configureDotsForDay(mealTime:[Int], quality:[Int]){
		makeBlankTimeDots()
		
		for i in 0..<quality.count{
			var color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
			var qualityLabel = String()
			switch quality[i] {
				case -1:
					color = R.color.badColor()!
					qualityLabel = "R"
				break
				case 0:
					color = R.color.mediumColor()!
					qualityLabel = "M"

				break
				case 1:
 					color = R.color.goodColor()!
					qualityLabel = "B"

				default:
					break
			}
			let hour = mealTime[i]
			timeDots[hour].color = color
			timeDots[hour].qualityText = qualityLabel
			timeDots[hour].activate()
		}
		setNeedsLayout()
	}
}
