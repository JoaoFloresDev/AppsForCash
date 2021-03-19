//
//  DailyHabits.swift
//  App
//
//  Created by Priscila Zucato on 28/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

enum DailyHabits {
    case drinkWater
    case exercise
    case fruit
    
    var title: String {
        switch self {
        case .drinkWater:   return "Tomou água?"
        case .exercise:     return "Praticou exercícios físicos?"
        case .fruit:        return "Comeu frutas?"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .drinkWater:   return R.image.water()
        case .exercise:     return R.image.exerciseIcon()
        case .fruit:        return R.image.fruits()
        }
    }
}
