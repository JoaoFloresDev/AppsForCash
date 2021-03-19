//
//  styleFunctions.swift
//  App
//
//  Created by Joao Flores on 27/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit


/// Functions to customize views
class StyleClass {

    func cropBounds(viewlayer: CALayer, cornerRadius: Float) {
        
        let imageLayer = viewlayer
        imageLayer.cornerRadius = CGFloat(cornerRadius)
        imageLayer.masksToBounds = true
    }
    
    func applicShadow(layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
    
    func appliGradient(view: UIView) {
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 0.0, y: 0.0)
        mask.endPoint = CGPoint(x: 0.0, y: 1)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor,whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        
        view.backgroundColor = UIColor.white
        mask.frame = view.bounds
        view.layer.mask = mask
    }
}


