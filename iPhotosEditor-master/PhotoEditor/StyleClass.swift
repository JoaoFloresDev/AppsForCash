//
//  styleFunctions.swift
//  App
//
//  Created by Joao Flores on 27/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class StyleClass {

    func cropBounds(viewlayer: CALayer, cornerRadius: Float) {
        
        let imageLayer = viewlayer
        imageLayer.cornerRadius = CGFloat(cornerRadius)
        imageLayer.masksToBounds = true
    }
    
    func applicShadow(Layer: CALayer) {
        
        Layer.masksToBounds = false
        Layer.shadowPath = UIBezierPath(rect: Layer.bounds).cgPath
        Layer.shouldRasterize = true
        
        Layer.shadowColor = UIColor.black.cgColor
        Layer.shadowOpacity = 0.2
        Layer.shadowOffset = CGSize.zero
        Layer.shadowRadius = 6
    }
}


