//
//  MealViewController.swift
//  App
//
//  Created by Pietro Pugliesi on 07/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController {
    @IBOutlet weak var registerMealView: RegisterMealView!
    @IBOutlet weak var dailyHabitsView: DailyHabitsView!
    
    var dataHandler: DataHandler?
    var dailyDiary: DailyDiary?
    var mealNote: String? {
        didSet {
            didSetMealNote()
        }
    }
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            dataHandler = try DataHandler.getShared()
        } catch {
            os_log("Couldn't get shared DataHandler.")
        }
        
        fetchDailyData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dailyHabitsView.setup(delegate: self)
        registerMealView.setup(delegate: self)
    }
    
    func updateDailyData() {
        guard let dailyDiary = self.dailyDiary else { return }
        do {
            try dataHandler?.createDailyDiary(quality: Int(dailyDiary.quality),
                                              didDrinkWater: dailyDiary.didDrinkWater,
                                              didPracticeExercise: dailyDiary.didPracticeExercise,
                                              didEatFruit: dailyDiary.didEatFruit)
        } catch {
            os_log("Couldn't update daily diary.")
        }
    }
    
    func didSetMealNote() {
        registerMealView.note = mealNote
    }
    
    func fetchDailyData() {
        do {
            let date = Date()
            let (year, month, day, _, _, _) = try date.getAllInformations()
            dailyDiary = try dataHandler?.loadDailyDiary(year: year, month: month, day: day)
            if dailyDiary == nil {
                createEmptyDailyData()
            }
            dailyHabitsView.setInitialDailyDiary(dailyDiary)
        } catch {
            os_log("There's still no daily data for today or something went wrong when trying to fetch.")
            createEmptyDailyData()
        }
    }
    
    private func createEmptyDailyData() {
        do {
            let date = Date()
                       let (year, month, day, _, _, _) = try date.getAllInformations()
            try dataHandler?.createDailyDiary(quality: 0, didDrinkWater: false, didPracticeExercise: false, didEatFruit: false)
            dailyDiary = try dataHandler?.loadDailyDiary(year: year, month: month, day: day)
            dailyHabitsView.setInitialDailyDiary(dailyDiary)
        } catch {
            os_log("Couldn't create new empty daily diary data.")
        }
    }
    
    // MARK: PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.mealViewController.toNoteModal.identifier
        {
            let vc = segue.destination as? AddNoteViewController
            vc?.delegate = self
            vc?.note = mealNote
        }
    }
}
// MARK: - REGISTER MEAL VIEW DELEGATE
extension MealViewController: RegisterMealViewDelegate {
    func dismissVCIfApplicable() {
        // Do nothing.
    }
    
    func saveMeal(quality: Int, hour: Int, minute: Int, note: String?) {
        do {
            try dataHandler?.createMeal(quality: quality, hour: hour, minute: minute, note: note)
        } catch {
            os_log("Couldn't create new meal.")
        }
    }
    
    func goToNote(note: String?) {
        performSegue(withIdentifier: R.segue.mealViewController.toNoteModal.identifier, sender: nil)
    }
    
    func goToInfo() {
        performSegue(withIdentifier: R.segue.mealViewController.toAboutMeal.identifier, sender: nil)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
// MARK: - DAILY HABITS VIEW DELEGATE
extension MealViewController: DailyHabitsViewDelegate {
    func dailyDiaryDidUpdate(_ diary: DailyDiary) {
        self.dailyDiary = diary
        updateDailyData()
    }
}
// MARK: - ADD NOTE VC DELEGATE
extension MealViewController: AddNoteVCDelegate {
    func didFinishEditingNote(_ note: String?) {
        mealNote = note
    }
}
