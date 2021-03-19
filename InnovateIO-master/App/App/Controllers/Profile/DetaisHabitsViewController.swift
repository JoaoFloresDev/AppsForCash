//
//  DetailsViewController.swift
//  App
//
//  Created by Joao Flores on 21/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class DetaisHabitsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //    MARK: - Constants
    let constraintViewInsertIdentifier = "Height"
    let viewInsertWeightHeight: CGFloat = 53
    let timeAnimation = 0.5
    let cornerRadiusViews: CGFloat = 10
    
    let tagLabelValueWater = 1000
    let tagLabelValueFruits = 2000
    let tagLabelValueExercise = 3000
    let tagLabelDateWeigh = 1001
    let tagViewInsertWeigh = 100
    
    //    MARK: - Variables
    let pickerData = ["✗", "✓"]
    
    var habitsDates = [String]()
    var weightValues = [Int]()
    var dataCells = [DataCell]()
    
    struct DataCell {
        var water: Int
        var fruits: Int
        var exercise: Int
        var date: String
    }
    
    //    MARK: - IBOutlet
    @IBOutlet weak var detailsTableview: UITableView!
    @IBOutlet weak var detaisNavigation: UINavigationItem!
    
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var fruitsLabel: UILabel!
    
    @IBOutlet weak var weightDateLabel: UILabel!
    
    @IBOutlet weak var viewInsertHabits: UIView!
    @IBOutlet weak var cellViewInsertHabits: UIView!
    
    //    MARK: - IBOutlet
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showInsertWeightView(_ sender: Any) {
        showCellInsert()
    }
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupTableView()
        setupPickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let presenter = self.presentingViewController?.children[0] as? ProfileViewController {
            presenter.setupGraphic()
            presenter.setupDataProfile()
            presenter.updateHeaderInformations()
        }
    }
    
    //    MARK: - TableView
    func setupTableView() {
        detailsTableview.delegate = self
        detailsTableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellCreator(indexPath: indexPath)
    }
    
    func cellCreator(indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailsTableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let valueWaterLabel = cell.viewWithTag(tagLabelValueWater) as! UILabel
        valueWaterLabel.text = pickerData[dataCells[dataCells.count - 1 - indexPath[1]].water]
        
        let valueFruitsLabel = cell.viewWithTag(tagLabelValueFruits) as! UILabel
        valueFruitsLabel.text = pickerData[dataCells[dataCells.count - 1 - indexPath[1]].fruits]
        
        let valueExerciseLabel = cell.viewWithTag(tagLabelValueExercise) as! UILabel
        valueExerciseLabel.text = pickerData[dataCells[dataCells.count - 1 - indexPath[1]].exercise]
        
        let dateLabel = cell.viewWithTag(tagLabelDateWeigh) as! UILabel
        dateLabel.text = dataCells[dataCells.count - 1  - indexPath[1]].date
        
        let cellViewWithe = cell.viewWithTag(tagViewInsertWeigh)!
        cellViewWithe.layer.cornerRadius = cornerRadiusViews
        
        return cell
    }
    
    // Delete Item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteValue(indexPath)
        }
    }
    
    //    MARK: - Data Management
    func loadData() {
        do {
            let plotter = try PlotGraphicClass()
            
            let months = plotter.getMonths()
            
            // Getting the current days last two months
            let dates: NSMutableArray = plotter.getFullDates(months)
            
            // Starting to populate and draw the charts...
            let numbersArray: [[Int]] = plotter.getHabitsValuesDetails(months)
            
            var datesArray = [String]()
            for x in 0...(dates.count - 1) {
                
                let aString = dates[x]
                datesArray.append(aString as! String)
            }
            
            habitsDates = datesArray
            weightValues = numbersArray[0]
            
            dataCells.removeAll()
            for i in 0...weightValues.count - 1 {
                let dataCell = DataCell(water: numbersArray[0][i], fruits: numbersArray[1][i], exercise: numbersArray[2][i], date: habitsDates[i])
                dataCells.append(dataCell)
            }
        }
        catch {
            os_log("[ERROR] Couldn't communicate with the operating system's internal calendar/time system or memory is too low!")
        }
    }
    
    func convertStringToDate(dateString: String) -> Date? {
        let fullDateArray = dateString.components(separatedBy: "/")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: fullDateArray[2]+"/"+fullDateArray[1]+"/"+fullDateArray[0])
        return someDateTime
    }
    
    func insertNewWeight(waterValue: Bool, fruitsValue: Bool, exerciseValue: Bool, date: Date?) {
        do {
            let dataHandler = try DataHandler.getShared()
            try dataHandler.createDailyDiaryInDate(quality: 1, didDrinkWater: waterValue, didPracticeExercise: exerciseValue, didEatFruit: fruitsValue, date: date!)
            alertInsert(titleAlert: "Concluido", messageAlert: "Seus dados foram atualizados")
        }
        catch DateError.calendarNotFound {
            os_log("[ERROR] Couldn't get the iOS calendar system!")
            alertInsert(titleAlert: "Erro", messageAlert: "Couldn't get the iOS calendar system!")
        }
        catch PersistenceError.cantSave {
            os_log("[ERROR] Couldn't save into local storage due to low memory!")
            alertInsert(titleAlert: "Erro", messageAlert: "Couldn't save into local storage due to low memory!")
        }
        catch {
            os_log("[ERROR] Unknown error occurred while registering the weight inside local storage!")
            alertInsert(titleAlert: "Erro", messageAlert: "Unknown error occurred while registering the weight inside local storage!")
        }
    }
    
    func deleteValue(_ indexPath: IndexPath) {
        insertNewWeight(waterValue: false, fruitsValue: false, exerciseValue: false, date: convertStringToDate(dateString: dataCells[dataCells.count - 1 - indexPath.row].date))
        loadData()
        detailsTableview.reloadData()
    }
    
//    MARK: - UI Insert Weight
    func showCellInsert() {
        let filteredConstraints = viewInsertHabits.constraints.filter { $0.identifier == constraintViewInsertIdentifier }
        if let yourConstraint = filteredConstraints.first {
            UIView.animate(withDuration: timeAnimation) {
                yourConstraint.constant = self.viewInsertWeightHeight
                self.view.layoutIfNeeded()
            }
        }
        exerciseTextField.becomeFirstResponder()
    }
    
    func hideCellInsertWeight() {
        let filteredConstraints = viewInsertHabits.constraints.filter { $0.identifier == constraintViewInsertIdentifier }
        if let yourConstraint = filteredConstraints.first {
            UIView.animate(withDuration: 0.5) {
                yourConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //    MARK: - Picker View
    func setupPickerView() {
        let pickerInsertWeight = UIPickerView()
        pickerInsertWeight.delegate = self
        exerciseTextField.delegate = self
        exerciseTextField.inputView = pickerInsertWeight
        exerciseTextField.inputAccessoryView = inputAccessoryViewPicker
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        selectInitialRowPickerView(pickerInsertWeight)
        hideCellInsertWeight()
        cellViewInsertHabits.layer.cornerRadius = cornerRadiusViews
        
        weightDateLabel.text = habitsDates.last
        exerciseTextField.text = pickerData[1]
        waterLabel.text = pickerData[1]
        fruitsLabel.text = pickerData[1]
    }
    
    @objc func cancelDatePicker() {
        dismissKeyboard()
    }
    
    @objc func doneDatePicker() {
        dismissKeyboard()
        
        let exerciseValue = self.exerciseTextField.text! == "✗" ? false : true
        let waterValue = self.waterLabel.text == "✗" ? false : true
        let fruitsValue = self.fruitsLabel.text == "✗" ? false : true
        
        insertNewWeight(waterValue: waterValue, fruitsValue: fruitsValue, exerciseValue: exerciseValue, date: convertStringToDate(dateString: weightDateLabel.text!))
        loadData()
        detailsTableview.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        hideCellInsertWeight()
    }
    
    var inputAccessoryViewPicker: UIView? {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Adicionar", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        return toolbar
    }
    
    func selectInitialRowPickerView(_ pickerData: UIPickerView) {
        pickerData.selectRow(Int(habitsDates.count - 1), inComponent: 3, animated: true)
        pickerData.selectRow(1, inComponent: 0, animated: true)
        pickerData.selectRow(1, inComponent: 1, animated: true)
        pickerData.selectRow(1, inComponent: 2, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var sizeValue: Int = 1
        switch component {
        case 3:
            sizeValue = habitsDates.count
        default:
            sizeValue = pickerData.count
        }
        return sizeValue
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var dataValue: String!
        switch component {
        case 3:
            dataValue = habitsDates[row]
        default:
            dataValue = pickerData[row]
        }
        
        return dataValue
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let rowWater = pickerView.selectedRow(inComponent: 0)
        let rowFruits = pickerView.selectedRow(inComponent: 1)
        let rowExercise = pickerView.selectedRow(inComponent: 2)
        let rowDate = pickerView.selectedRow(inComponent: 3)
        
        exerciseTextField.text = pickerData[rowExercise]
        waterLabel.text = pickerData[rowWater]
        fruitsLabel.text = pickerData[rowFruits]
        
        weightDateLabel.text = habitsDates[rowDate]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var sizeValue: CGFloat!
        switch component {
        case 0:
            sizeValue = 60
            
        case 1:
            sizeValue = 60
            
        case 2:
            sizeValue = 60
            
        default:
            sizeValue = 200
        }
        return sizeValue
    }

//    MARK: - ALERTS
    func alertInsert(titleAlert: String, messageAlert: String) {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CONVERTIONS
    func convertWeightStringToFloat() -> Float {
        let valueArray = self.exerciseTextField.text!.split(separator: ",")
        
        var convertedValue: Float = 0
        if let integer = Float(valueArray[0]) {
            convertedValue = integer
        }
        
        let decimalString = valueArray[1]
        let decimalStringReplace = decimalString.replacingOccurrences(of: " %", with: "")
        if let decimal = Float(decimalStringReplace) {
            convertedValue = convertedValue + decimal/100
        }
        return convertedValue
    }
}
