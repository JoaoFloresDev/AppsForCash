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
        case .average:  return "Média"
        case .good:     return "Boa"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .bad:      return R.color.badColor()
        case .average:  return R.color.mediumColor()
        case .good:     return R.color.goodColor()
        }
    }
    
    var defaultNoteForMeal: String {
        switch self {
        case .bad:
            return "Minha alimentação não foi muito saudável. Que tal tentar comer vegetais ou frutas da próxima vez?"
        case .average:
            return "Não comi bem nem mal. Acho que ainda posso melhorar."
        case .good:
            return "Isso aí! Comi muito bem, espero continuar assim!"
        }
    }
}
