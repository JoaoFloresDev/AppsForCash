//
//  MealHistoryViewController.swift
//  App
//
//  Created by Priscila Zucato on 06/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log
import DHSmartScreenshot

class MealHistoryViewController: UIViewController {
    @IBOutlet weak var historyTableView: UITableView!
    
    var shouldShareWhenPresented = false
    
    var dataHandler: DataHandler?
    var receivedDates: [Date] = [] {
        didSet {
            fetchMeals()
        }
    }
    var meals: [Date : [Meal]] = [:]
    var dateSelected: Date = Date()
    var mealSelected: Meal?

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        do {
            dataHandler = try DataHandler.getShared()
        } catch {
            os_log("Couldn't get shared DataHandler.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateSelected = Date()
        mealSelected = nil
        fetchMeals()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldShareWhenPresented {
            shareScreenshot()
        }
    }
    
// MARK: - Methods
    func fetchMeals() {
        for date in receivedDates {
            do {
                let (year, month, day, _, _, _) = try date.getAllInformations()
                let mealsForDate = try dataHandler?.loadMeals(year: year, month: month, day: day)
                meals[date] = orderByTime(mealsForDate ?? [])
            } catch {
                os_log("Couldn't fetch meals for date.")
            }
        }
        
        historyTableView?.reloadData()
    }
    
    func orderByTime(_ meals: [Meal]) -> [Meal] {
        return meals.sorted { (meal1, meal2) -> Bool in
            if meal1.hour != meal2.hour {
                return meal1.hour < meal2.hour
            } else {
                return meal1.minute < meal2.minute
            }
        }
    }
    
    func deleteMeal(_ mealID: String) {
        do {
            try dataHandler?.deleteMeal(mealID: mealID)
            fetchMeals()
        } catch {
            os_log("Couldn't delete meal.")
        }
    }
    
    func setupTableView() {
        historyTableView.register(UINib(resource: R.nib.mealHistoryTableViewCell),
                                  forCellReuseIdentifier: R.reuseIdentifier.mealHistoryTableViewCell.identifier)
        historyTableView.register(UINib(resource: R.nib.mealHistoryHeader),
                                  forHeaderFooterViewReuseIdentifier: "MealHistoryHeader")
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    func shareScreenshot() {
        let screenshot = historyTableView.screenshot()
        
        let items: [Any] = [screenshot]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
// MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == R.segue.mealHistoryViewController.toRegisterMeal.identifier
        {
            let vc = segue.destination as? AddDatedMealViewController
            vc?.receivedDate = dateSelected
            vc?.receivedMeal = mealSelected
        }
    }
    
// MARK: - Actions
    @IBAction func shareTapped(_ sender: Any) {
        shareScreenshot()
    }
}

// MARK: - Table View Data Source and Delegate
extension MealHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return receivedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = receivedDates[section]
        let sectionMeals = meals[date]
        
        return sectionMeals?.count == 0 || sectionMeals == nil ? 1 : sectionMeals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mealHistoryTableViewCell.identifier) as? MealHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let date = receivedDates[indexPath.section]
        var meal: Meal?
        if meals[date]?.count ?? 0 > indexPath.row {
            meal = meals[date]?[indexPath.row]
        }
        
        cell.setup(meal: meal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MealHistoryHeader") as? MealHistoryHeader else {
            return nil
        }
        
        let date = receivedDates[section]
        header.setup(date: date, delegate: self)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? MealHistoryTableViewCell else { return nil }
        
        if cell.noMealView.isHidden == true {
            let date = receivedDates[indexPath.section]
            guard let mealID = meals[date]?[indexPath.row].id else { return nil }
            
            let action = UIContextualAction(
                style: .destructive,
                title: "Deletar",
                handler: { (action, view, completion) in
                    self.deleteMeal(mealID)
                    completion(true)
            })

            action.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? MealHistoryTableViewCell else { return nil }
        
        if cell.noMealView.isHidden == true {
            let date = receivedDates[indexPath.section]
            guard let meal = meals[date]?[indexPath.row] else { return nil }
            
            let action = UIContextualAction(
                style: .normal,
                title: "Editar",
                handler: { (action, view, completion) in
                    self.dateSelected = date
                    self.mealSelected = meal
                    self.performSegue(withIdentifier: R.segue.mealHistoryViewController.toRegisterMeal.identifier, sender: nil)
            })

            action.backgroundColor = .gray
            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = receivedDates[indexPath.section]
        var meal: Meal?
        if meals[date]?.count ?? 0 > indexPath.row {
            meal = meals[date]?[indexPath.row]
        }
        
        self.dateSelected = date
        self.mealSelected = meal
        self.performSegue(withIdentifier: R.segue.mealHistoryViewController.toRegisterMeal.identifier, sender: nil)
    }
}

// MARK: - Meal History Header Delegate
extension MealHistoryViewController: MealHistoryHeaderDelegate {
    func plusButtonTapped(date: Date) {
        self.dateSelected = date
        performSegue(withIdentifier: R.segue.mealHistoryViewController.toRegisterMeal.identifier, sender: nil)
    }
}
