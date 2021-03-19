//
//  EditDataViewController.swift
//  App
//
//  Created by Joao Flores on 07/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//
  
import UIKit
import os.log
import NumericPicker

class EditDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    
    //MARK: - Variables
    var defaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    // Interface builder outlets
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var plainingTextView: UITextView!
    
    //MARK: - Variables
    // Private properties related to the Edit View
    private var dataHandler: DataHandler?
    let integerPickerData = (30...120).map { String($0) }
    var decimalPickerData2 = (0...9).map { String($0) }
    
    //    MARK: - IBAction
    
    /// Saves the new data into local storage.
    /// - Parameter sender: The tap action.
    @IBAction func saveViewController(_ sender: Any) {
        saveNewData()
        updateDataProfile()
        self.dismiss(animated: true, completion: nil)
        
        if let presenter = self.presentingViewController?.children[0] as? ProfileViewController {
            presenter.setupGraphic()
        }
    }
    
    /// Closes the view.
    /// - Parameter sender: The tap / swipe action.
    @IBAction func closeViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Clears the goal field.
    /// - Parameter sender: The tap action.
    @IBAction func clearGoals(_ sender: Any) {
        plainingTextView.text = ""
    }
    
    //    MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.dataHandler = try DataHandler.getShared()
        }
        catch {
            os_log("[ERROR] Can't get Data Handler instance, maybe the memory is too low?")
        }
        
        plainingTextView.delegate = self
        
        setupTexts()
        setupStyle()
        setupPickerView()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            plainingTextView.contentInset = .zero
        } else {
            plainingTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        plainingTextView.scrollIndicatorInsets = plainingTextView.contentInset

        let selectedRange = plainingTextView.selectedRange
        plainingTextView.scrollRangeToVisible(selectedRange)
    }
    
    func updateDataProfile() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateDataProfile"),
                                        object: nil, userInfo: nil)
    }
    
    //    MARK: - Conversion
    func convertWeightStringToFloat() -> Float {
        let valueArray = self.weightTextField.text!.split(separator: ",")
        let integer = Float(valueArray[0])
        var convertedValue = integer ?? 0
        
        if let decimal = Float(valueArray[1]) {
            convertedValue = convertedValue + decimal/100
        }
        
        return convertedValue
    }
    
    //    MARK: - UserDefaults
    
    /// Setups the initial state of the components on the view.
    func setupTexts() {
        
        // Loading the Plain
        plainingTextView.text = defaults.string(forKey: "Plain")
        
        // Loading the Weight
        weightTextField.text = defaults.string(forKey: "Weight")
    }
    
    /// Saves the new data into local storage.
    /// The data that will be saved by using the User Defaults and the Core Data.
    func saveNewData() {
        
        // Saving the Plain
        defaults.set (plainingTextView.text, forKey: "Plain")
        
        // Saving the Weight
        if self.weightTextField.text != nil && !self.weightTextField.text!.isEmpty {
            
            let weightData = weightTextField.text!.replacingOccurrences(of: " Kg", with: "")
            defaults.set (weightData, forKey: "Weight")
            
            let convertedValue = convertWeightStringToFloat ()
            
            do {
                try self.dataHandler?.createWeight(value: convertedValue, date: nil)
            }
            catch DateError.calendarNotFound {
                os_log("[ERROR] Couldn't get the iOS calendar system!")
            }
            catch PersistenceError.cantSave {
                os_log("[ERROR] Couldn't save into local storage due to low memory!")
            }
            catch {
                os_log("[ERROR] Unknown error occurred while registering the weight inside local storage!")
            }
        }
    }
    
    //    MARK: - Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //    MARK: - Style
    func setupStyle() {
        plainingTextView.layer.cornerRadius = 10
        plainingTextView.layer.borderWidth = 1.0
        plainingTextView.layer.borderColor = UIColorFromRGB(rgbValue: 0xCDCDCD).cgColor
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //    MARK: - Picker View
    fileprivate func setupPickerView() {
        let thePicker = UIPickerView()
        thePicker.delegate = self
        weightTextField.inputView = thePicker
        
        var i = 0
        for value in decimalPickerData2 {
            decimalPickerData2[i] = String((Int(value)!) * 10)
            if(decimalPickerData2[i] == "0") {
                decimalPickerData2[i] = "00"
            }
            i = i + 1
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

        selectInitialRowPickerView(thePicker)
    }
    
    fileprivate func selectInitialRowPickerView(_ thePicker: UIPickerView) {
        if self.weightTextField.text != nil && !self.weightTextField.text!.isEmpty {
            let valueArray = self.weightTextField.text!.split(separator: ",")
            if let integer = Float(valueArray[0]) {
                thePicker.selectRow(Int(integer - 30), inComponent: 0, animated: true)
            }
            if let decimal = Float(valueArray[1]) {
                thePicker.selectRow(Int(decimal/10), inComponent: 2, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var sizeValue: Int!
        switch component {
        case 0:
            sizeValue = integerPickerData.count
        case 1:
            sizeValue = 1
        default:
            sizeValue = decimalPickerData2.count
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
        default:
            dataValue = decimalPickerData2[row]
        }
        
        return dataValue
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let rowInteger = pickerView.selectedRow(inComponent: 0)
        let rowDecimal = pickerView.selectedRow(inComponent: 2)
        
        weightTextField.text = integerPickerData[rowInteger] + "," + decimalPickerData2[rowDecimal] + " Kg"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
}
