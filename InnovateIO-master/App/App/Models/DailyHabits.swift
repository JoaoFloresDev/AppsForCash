//
//  DailyHabits.swift
//  App
//
//  Created by Priscila Zucato on 28/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

enum DailyHabits: String {
    case drinkWater = "drinkWater"
    case exercise = "exercise"
    case fruit = "fruit"
    
    var title: String {
        switch self {
        case .drinkWater:   return "Tomei água"
        case .exercise:     return "Pratiquei exercícios físicos"
        case .fruit:        return "Comi frutas"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .drinkWater:   return R.image.water()
        case .exercise:     return R.image.exerciseIcon()
        case .fruit:        return R.image.fruits()
        }
    }
    
    var color: UIColor? {
        switch self {
        case .drinkWater:   return R.color.habitsWaterColor()
        case .exercise:     return R.color.habitsExerciceColor()
        case .fruit:        return R.color.habitsFruitsColor()
        }
    }
}
