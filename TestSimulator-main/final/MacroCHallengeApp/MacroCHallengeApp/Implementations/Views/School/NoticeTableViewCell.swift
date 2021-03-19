//
//  NoticeTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 07/10/20.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    // MARK: -IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: -Lifecycle
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
