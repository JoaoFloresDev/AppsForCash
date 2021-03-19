//
//  WeekdaysTableViewCell.swift
//  App
//
//  Created by Priscila Zucato on 03/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class WeekdaysTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.accessoryType = selected ? .checkmark : .none
    }
}
