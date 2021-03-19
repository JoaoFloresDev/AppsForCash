//
//  DetailsViewController.swift
//  App
//
//  Created by Joao Flores on 21/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class DetailsWeightViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //    MARK: - Constants
    let constraintViewInsertIdentifier = "Height"
    let viewInsertWeightHeight: CGFloat = 53
    let timeAnimation = 0.5
    let cornerRadiusViews: CGFloat = 10
    let tagLabelValueWeigh = 1000
    let tagLabelDateWeigh = 1001
    let tagViewInsertWeigh = 100
    
    //    MARK: - Variables
    var defaults = UserDefaults.standard
    let integerPickerData = (30...120).map { String($0) }
    var decimalPickerData = (0...9).map { String($0) }
    var weightDates = [String]()
    var weightValues = [Float]()
    var dataCells = [DataCell]()
    
    struct DataCell {
        var value: Float
        var date: String
    }
    
    //    MARK: - IBOutlet
    @IBOutlet weak var detailsTableview: UITableView!
    @IBOutlet weak var detaisNavigation: UINavigationItem!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightDateLabel: UILabel!
    @IBOutlet weak var viewInsertWeight: UIView!
    @IBOutlet weak var cellViewInsertWeight: UIView!
    
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
        updateDataProfile()
        if let presenter = self.presentingViewController?.children[0] as? ProfileViewController {
            presenter.setupGraphic()
            presenter.setupDataProfile()
        }
    }
    
    func updateDataProfile() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateDataProfile"),
                                        object: nil, userInfo: nil)
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
        
        let valueLabel = cell.viewWithTag(tagLabelValueWeigh) as! UILabel
        let stringValue = String(dataCells[dataCells.count - 1 - indexPath[1]].value)   + "0 Kg"
        
        valueLabel.text = stringValue.replacingOccurrences(of: ".", with: ",")
        
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
            let numbersArray: [[Float]] = plotter.getWeightsValuesDetails(months)
            
            var datesArray = [String]()
            for x in 0...(dates.count - 1) {
                let aString = dates[x]
                datesArray.append(aString as! String)
            }
            weightDates = datesArray
            weightValues = numbersArray[0]
            
            dataCells.removeAll()
            for i in 0...weightValues.count - 1 {
                if(weightValues[i] != 0) {
                    let dataCell = DataCell(value: weightValues[i], date: weightDates[i])
                    dataCells.append(dataCell)
                }
            }
            print(dataCells)
        }
        catch {
            os_log("[ERROR] Couldn't communicate with the operating system's internal calendar/time system or memory is too low!")
        }
    }
    
    func convertStringToDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: dateString)
        return date
    }
    
    func insertNewWeight(value: Float, date: Date?) {
        do {
            let dataHandler = try DataHandler.getShared()
            try dataHandler.createWeight(value: value, date: date)
        
            checkInCurrentDay(date: date!)
            alertInsert(success: true)
        }
        catch DateError.calendarNotFound {
            os_log("[ERROR] Couldn't get the iOS calendar system!")
            alertInsert(success: false)
        }
        catch PersistenceError.cantSave {
            os_log("[ERROR] Couldn't save into local storage due to low memory!")
            alertInsert(success: false)
        }
        catch {
            os_log("[ERROR] Unknown error occurred while registering the weight inside local storage!")
            alertInsert(success: false)
        }
    }
    
    func checkInCurrentDay(date: Date) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        let result2 = formatter.string(from: currentDate)
        if(result == result2) {
            defaults.set (weightTextField.text, forKey: "Weight")
        }
    }
    func deleteValue(_ indexPath: IndexPath) {
        insertNewWeight(value: 00.00, date: convertStringToDate(dateString: dataCells[dataCells.count - 1 - indexPath.row].date))
        loadData()
        detailsTableview.reloadData()
    }
    
//    MARK: - UI Insert Weight
    func showCellInsert() {
        let filteredConstraints = viewInsertWeight.constraints.filter { $0.identifier == constraintViewInsertIdentifier }
        if let yourConstraint = filteredConstraints.first {
            UIView.animate(withDuration: timeAnimation) {
                yourConstraint.constant = self.viewInsertWeightHeight
                self.view.layoutIfNeeded()
            }
        }
        weightTextField.becomeFirstResponder()
    }
    
    func hideCellInsertWeight() {
        let filteredConstraints = viewInsertWeight.constraints.filter { $0.identifier == constraintViewInsertIdentifier }
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
        weightTextField.delegate = self
        weightTextField.inputView = pickerInsertWeight
        weightTextField.inputAccessoryView = inputAccessoryViewPicker
        adjustPickerData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        selectInitialRowPickerView(pickerInsertWeight)
        hideCellInsertWeight()
        cellViewInsertWeight.layer.cornerRadius = cornerRadiusViews
        
        weightDateLabel.text = weightDates.last
        weightTextField.text = integerPickerData[0] + "," + decimalPickerData[0] + " Kg"
    }
    
    @objc func cancelDatePicker() {
        dismissKeyboard()
    }
    
    @objc func doneDatePicker() {
        dismissKeyboard()
        insertNewWeight(value: convertWeightStringToFloat(), date: convertStringToDate(dateString: weightDateLabel.text!))
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
        pickerData.selectRow(Int(weightDates.count - 1), inComponent: 3, animated: true)
        pickerData.selectRow(0, inComponent: 0, animated: true)
        pickerData.selectRow(0, inComponent: 2, animated: true)
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
        case 0:
            sizeValue = integerPickerData.count
        case 1:
            sizeValue = 1
            
        case 2:
            sizeValue = decimalPickerData.count
        default:
            sizeValue = weightDates.count
        }
        return sizeValue
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var dataValue: String!
        switch component {
        case 0:
            dataValue = integerPickerData[row]
        case 1:
            dataValue = ","
            
        case 2:
            dataValue = decimalPickerData[row]
            
        default:
            dataValue = weightDates[row]
        }
        
        return dataValue
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let rowInteger = pickerView.selectedRow(inComponent: 0)
        let rowDecimal = pickerView.selectedRow(inComponent: 2)
        let rowDate = pickerView.selectedRow(inComponent: 3)
        
        weightTextField.text = integerPickerData[rowInteger] + "," + decimalPickerData[rowDecimal] + " Kg"
        weightDateLabel.text = weightDates[rowDate]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var sizeValue: CGFloat!
        switch component {
        case 0:
            sizeValue = 50.0
            
        case 1:
            sizeValue = 15.0
            
        case 2:
            sizeValue = 50.0
            
        default:
            sizeValue = 200.0
        }
        return sizeValue
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func adjustPickerData() {
        var i = 0
        for value in decimalPickerData {
            decimalPickerData[i] = String((Int(value)!) * 10)
            if(decimalPickerData[i] == "0") {
                decimalPickerData[i] = "00"
            }
            i = i + 1
        }
    }

//    MARK: - ALERTS
    func alertInsert(success: Bool) {
        var titleAlert = "Concluido"
        var messageAlert = "Seus dados foram atualizados"
        if(!success) {
            titleAlert = "Erro"
            messageAlert = "Tente novamente"
        }
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CONVERTIONS
    func convertWeightStringToFloat() -> Float {
        let valueArray = self.weightTextField.text!.split(separator: ",")
        
        var convertedValue: Float = 0
        if let integer = Float(valueArray[0]) {
            convertedValue = integer
        }
        
        let decimalString = valueArray[1]
        let decimalStringReplace = decimalString.replacingOccurrences(of: " Kg", with: "")
        if let decimal = Float(decimalStringReplace) {
            convertedValue = convertedValue + decimal/100
        }
        return convertedValue
    }
}
