//
//  SchoolsTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 07/10/20.
//

import UIKit

class SchoolsTableViewCell: UITableViewCell {
    // MARK: -IBOutlets
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: -Lifecyle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private methods
    /**
     
     Método responsável por definir qualidades visuais (sombra, corner radius) da célula.
     
     */
    
    private func setupCardView() {
        self.bgView.layer.cornerRadius = 6
        self.bgView.layer.shadowColor = UIColor.black.cgColor
        self.bgView.layer.shadowOpacity = 0.25
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.bgView.layer.shadowRadius = 1
        self.bgView.layer.masksToBounds = false
    }
}
