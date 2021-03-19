//
//  HowToUseViewController.swift
//  App
//
//  Created by Joao Flores on 04/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class HowToUseViewController: UIViewController {

    @IBOutlet weak var firstCell: UIView!
    @IBOutlet weak var secondCell: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleClass().cropBounds(viewlayer: firstCell.layer, cornerRadius: 10)
        StyleClass().cropBounds(viewlayer: secondCell.layer, cornerRadius: 10)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
