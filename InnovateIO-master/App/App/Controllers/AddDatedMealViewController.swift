//
//  AddDatedMealViewController.swift
//  App
//
//  Created by Priscila Zucato on 08/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class AddDatedMealViewController: UIViewController {
    @IBOutlet weak var registerMealView: RegisterMealView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dataHandler: DataHandler?
    var receivedDate: Date? {
        didSet {
            modifiedDate = receivedDate
        }
    }
    var modifiedDate: Date?
    var receivedMeal: Meal? {
        didSet {
            modifiedMeal = receivedMeal
        }
    }
    var modifiedMeal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            dataHandler = try DataHandler.getShared()
        } catch {
            os_log("Couldn't get shared DataHandler.")
        }
        
        datePicker.date = receivedDate ?? Date()
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        
        if let meal = receivedMeal {
            registerMealView.set(meal: meal)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerMealView.setup(delegate: self)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        modifiedDate = sender.date
    }
}
// MARK: - REGISTER MEAL VIEW DELEGATE
extension AddDatedMealViewController: RegisterMealViewDelegate {
    func dismissVCIfApplicable() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func saveMeal(quality: Int, hour: Int, minute: Int, note: String?) {
        guard let date = self.modifiedDate else { return }
        do {
            let (year, month, day, _, _, _) = try date.getAllInformations()
            
            // When received meal is not nil, user is modifying a pre-existing meal. We then  delete the meal he wants to modify and create a new one.
            if let receivedMealID = receivedMeal?.id {
                try dataHandler?.deleteMeal(mealID: receivedMealID)
            }
            
            try dataHandler?.createMeal(quality: quality,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            note: note)
            
        } catch {
            os_log("Couldn't create new meal.")
        }
    }
    
    func goToNote(note: String?) {
        if let addNoteViewController = R.storyboard.meals.addNoteViewController() {
            addNoteViewController.delegate = self
            addNoteViewController.note = note
            self.present(addNoteViewController, animated: true, completion: nil)
        }
    }
    
    func goToInfo() {
        performSegue(withIdentifier: R.segue.addDatedMealViewController.toAboutMeal.identifier, sender: nil)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
// MARK: - ADD NOTE VC DELEGATE
extension AddDatedMealViewController: AddNoteVCDelegate {
    func didFinishEditingNote(_ note: String?) {
        modifiedMeal?.note = note
        registerMealView.note = note
    }
}
