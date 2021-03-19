//
//  MealHistoryHeader.swift
//  App
//
//  Created by Priscila Zucato on 07/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol MealHistoryHeaderDelegate {
    func plusButtonTapped(date: Date)
}

class MealHistoryHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: MealHistoryHeaderDelegate?
    var date: Date?

    func setup(date: Date, delegate: MealHistoryHeaderDelegate) {
        self.delegate = delegate
        self.date = date
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd MMMM yyyy"
        let formatedDate = formatter.string(from: date)
        let formatedElements = formatedDate.components(separatedBy: " ")
        let weekday = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        titleLabel.text = weekday.capitalized + ", \(formatedElements[0]) de \(formatedElements[1]) de \(formatedElements[2])"
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        guard let date = self.date else { return }
        delegate?.plusButtonTapped(date: date)
    }
}
