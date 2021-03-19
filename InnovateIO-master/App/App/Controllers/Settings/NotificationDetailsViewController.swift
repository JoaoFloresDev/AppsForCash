//
//  NotificationDetailsViewController.swift
//  App
//
//  Created by Priscila Zucato on 02/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {
    @IBOutlet weak var weekdaysTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var notification: NotificationType?
    var notificationInfo: NotificationInfoTuple?
    let notificationService = NotificationService.shared
    
    var weekdays: [String] = []
    let weekdaysIDs = [2,3,4,5,6,7,1]
    var selectedWeekdaysIDs: [Int] = []
    var selectedTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setDaysOfWeek()
        setTimeOnPicker()
        setSelectedDaysOfWeek()
    }
    
// MARK: - Methods
    func setupTableView() {
        weekdaysTableView.delegate = self
        weekdaysTableView.dataSource = self
    }
    
    func setDaysOfWeek() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt-BR")
        weekdays = formatter.weekdaySymbols
        let sunday = weekdays.remove(at: 0)
        weekdays.append(sunday)
    }
    
    func setTimeOnPicker() {
        guard let info = notificationInfo else { return }
        let hour = info.hour
        let minute = info.minute
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        datePicker.date = Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func setSelectedDaysOfWeek() {
        guard let info = notificationInfo else { return }
        selectedWeekdaysIDs = info.weekdays
        
        weekdaysTableView.reloadData()
    }

// MARK: - Actions
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        selectedTime = sender.date
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let notificationType = notification, var info = notificationInfo else { return }
        info.weekdays = selectedWeekdaysIDs
        
        if let date = selectedTime {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            if let hour = dateComponents.hour, let minute = dateComponents.minute {
                info.hour = hour
                info.minute = minute
            }
        }
        notificationService.persistNotificationSettings(notificationType: notificationType, notificationInfo: info)
        
        let alert = UIAlertController(title: "Salvo!", message: "Suas alterações foram salvas.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Table View Delegate and Data Source
extension NotificationDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeekdaysTableViewCell()
        cell.textLabel?.text = weekdays[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dayOfWeekID = weekdaysIDs[indexPath.row]
        let shouldSelect = selectedWeekdaysIDs.contains(dayOfWeekID)
        
        if shouldSelect {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weekdayID = weekdaysIDs[indexPath.row]
        selectedWeekdaysIDs.append(weekdayID)
        selectedWeekdaysIDs = Array(Set(selectedWeekdaysIDs))
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let weekdayID = weekdaysIDs[indexPath.row]
        selectedWeekdaysIDs.removeAll { $0 == weekdayID }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repetir"
    }
}
