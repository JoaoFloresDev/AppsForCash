//
//  CardsViewController.swift
//  Calculadora
//
//  Created by Joao Flores on 31/10/19.
//  Copyright © 2019 Gustavo Lima. All rights reserved.
//

import UIKit
import StoreKit
class CardsViewController: UIViewController {
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
        rateApp()
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var buttonUpgrade: UIView!
    
    override func viewDidLoad() {
        buttonUpgrade.layer.cornerRadius = 10
        buttonUpgrade.clipsToBounds = true
    }
}
