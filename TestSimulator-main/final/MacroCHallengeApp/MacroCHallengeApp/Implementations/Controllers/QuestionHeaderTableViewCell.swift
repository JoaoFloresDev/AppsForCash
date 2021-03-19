//
//  QuestionHeaderTableViewCell.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 14/10/20.
//

import UIKit

class QuestionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var imgClock: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
