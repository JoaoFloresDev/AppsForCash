//
//  InformationsViewController.swift
//  Calculator Notes
//
//  Created by Joao Flores on 29/04/20.
//  Copyright © 2020 MakeSchool. All rights reserved.
//

import UIKit

class InformationsViewController: UIViewController {

//    MARK: - IBOutlets
    @IBOutlet weak var matrixView: UIView!
    
    @IBOutlet weak var Q1: UIView!
    @IBOutlet weak var Q2: UIView!
    @IBOutlet weak var Q3: UIView!
    @IBOutlet weak var Q4: UIView!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var squareView: UIView!
    
    @IBOutlet weak var DoView: UIView!
    @IBOutlet weak var DecideView: UIView!
    @IBOutlet weak var DelegateView: UIView!
    @IBOutlet weak var DeleteView: UIView!
    @IBOutlet weak var ImportantView: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Label1.text = "Important"
        Label2.text = "Not Important"
        
        Label1.transform = CGAffineTransform(rotationAngle: -3.14/2)
        Label2.transform = CGAffineTransform(rotationAngle: -3.14/2)
        
        Label1.frame = CGRect(x: 10, y: Q1.center.y + 15, width: 20, height: 138.5)
        Label2.frame = CGRect(x: 10, y: Q4.center.y + 15, width: 20, height: 138.5)
        
        StyleClass().cropBounds(viewlayer: Q1.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: Q2.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: Q3.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: Q4.layer, cornerRadius: 10)
        
        StyleClass().applicShadow(Layer: Q1.layer)
        StyleClass().applicShadow(Layer: Q2.layer)
        StyleClass().applicShadow(Layer: Q3.layer)
        StyleClass().applicShadow(Layer: Q4.layer)
        
        StyleClass().cropBounds(viewlayer: DecideView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: DelegateView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: DeleteView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: ImportantView.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: DoView.layer, cornerRadius: 10)
        
        StyleClass().applicShadow(Layer: DecideView.layer)
        StyleClass().applicShadow(Layer: DelegateView.layer)
        StyleClass().applicShadow(Layer: DeleteView.layer)
        StyleClass().applicShadow(Layer: ImportantView.layer)
        StyleClass().applicShadow(Layer: DoView.layer)
        
        StyleClass().cropBounds(viewlayer: matrixView.layer, cornerRadius: 10)
        StyleClass().applicShadow(Layer: matrixView.layer)
        
        StyleClass().cropBounds(viewlayer: upgradeButton.layer, cornerRadius: 10)
    }

}
