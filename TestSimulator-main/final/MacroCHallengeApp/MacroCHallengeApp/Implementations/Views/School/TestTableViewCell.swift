//
//  TestTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 06/10/20.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    // MARK: -IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var circularProgressLabel: UILabel!
    @IBOutlet weak var circularProgressView: UIView!
    
    // MARK: - Lifecyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingShadowAndCornerRadiusOnView(view: cardView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private Methods
    
    /**
     
     Método responsável por acrescentar sombra e corner radius em uma view.
     
     - parameters view: view no qual será acrescentado sombra e corner radius.
     
     */
    
    private func settingShadowAndCornerRadiusOnView(view: UIView) {
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
    }
}
