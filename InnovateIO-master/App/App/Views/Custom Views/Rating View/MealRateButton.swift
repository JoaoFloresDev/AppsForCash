//
//  MealRateButtonView.swift
//  App
//
//  Created by Pietro Pugliesi on 23/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import UIKit

class MealRateButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }

    var rating: Rating = Rating.good
    var isTheSelectedButton: Bool = false {
        didSet {
            setSelected()
        }
    }
    
    func setupButton() {
        setTitle()
        setBorder()
    }
    
    private func setTitle() {
        self.setTitle(rating.title, for: .normal)
    }
    
    private func setBorder() {
        self.layer.borderWidth = 2
        self.layer.borderColor = rating.color?.cgColor
    }
    
    private func setSelected() {
        self.backgroundColor = isTheSelectedButton ? rating.color : .clear
        self.setTitleColor(isTheSelectedButton ? .white : rating.color, for: .normal)
    }
}
