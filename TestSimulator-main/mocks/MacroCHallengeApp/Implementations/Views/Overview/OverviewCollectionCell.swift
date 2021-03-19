//
//  SchoolsTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 07/10/20.
//

import UIKit

class OverviewCollectionCell: UICollectionViewCell {
	// MARK: -IBOutlets
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var stateImage: UIImageView!

	// MARK: -Lifecyle
	override func awakeFromNib() {
		super.awakeFromNib()
		setupCardView()
	}

	// MARK: - Private methods
	/**

	Método responsável por definir qualidades visuais (sombra, corner radius) da célula.

	*/
	private func setupCardView() {
		stateImage.isHidden = true
		bgView.layer.borderWidth = 3
		bgView.layer.cornerRadius = 5

		bgView.layer.borderColor = UIColor(red:25/255, green:95/255, blue:230/255, alpha: 1).cgColor
		numberLabel.textColor = UIColor(red:25/255, green:95/255, blue:230/255, alpha: 1)

	}
}
