//
//  QuestionButtonsTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 09/10/20.
//

import UIKit

class QuestionButtonsTableViewCell: UITableViewCell {

    var controller: QuestionViewControllerProtocol?
    
    // MARK: - Outlets

    @IBAction func previousWasSubmited(_ sender: Any) {
        self.controller?.previousWasSubmitted()
    }
    @IBAction func nextWasSubmited(_ sender: Any) {
        self.controller?.nextWasSubmitted()
    }
    
    @IBOutlet weak var cardAnterior: UIView!
    @IBOutlet weak var cardProximo: UIView!
    
    // MARK: - Lifecyle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCardView() {
        cardAnterior.layer.borderWidth = 4
        // 0x195fe6
        cardAnterior.layer.borderColor = UIColor(red:19/255, green:95/255, blue:230/255, alpha: 1).cgColor
        cardAnterior.layer.cornerRadius = 10
    }
}
