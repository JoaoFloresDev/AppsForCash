//
//  Ratings.swift
//  App
//
//  Created by Priscila Zucato on 28/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

enum Rating: Int {
    case bad = -1
    case average = 0
    case good = 1
    
    var title: String {
        switch self {
        case .bad:      return "Ruim"
        case .average:  return "Médio"
        case .good:     return "Bom"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .bad:      return R.color.badColor()
        case .average:  return R.color.mediumColor()
        case .good:     return R.color.goodColor()
        }
    }
}
