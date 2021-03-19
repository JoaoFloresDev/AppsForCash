//
//  NotificationSettingsViewController.swift
//  App
//
//  Created by Priscila Zucato on 01/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController {
    @IBOutlet weak var notificationsTableView: UITableView!
    
    let notificationService = NotificationService.shared
    
    let dataSource: [NotificationSettingsHeaders] = [.meals, .weeklyUpdate]
    var selectedNotification: NotificationType?
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationsTableView?.reloadData()
    }
    
// MARK: - Methods
    func setupTableView() {
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(UINib(resource: R.nib.notificationSettingsCell),
                                        forCellReuseIdentifier: R.reuseIdentifier.notificationSettingsCell.identifier)
    }
    
// MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotificationDetailsViewController {
            guard let selectedNotification = selectedNotification else {
                return
            }
            vc.notification = selectedNotification
            vc.notificationInfo = notificationService.getNotificationSettings(for: selectedNotification)
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = dataSource[section]
        return section.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationSettingsCell.identifier) as? NotificationSettingsCell else {
            return UITableViewCell()
        }
        
        let section = dataSource[indexPath.section]
        let notification = section.notifications[indexPath.row]
        let info = notificationService.getNotificationSettings(for: notification)
        
        cell.enabledSwitch.isOn = notificationService.getNotificationIsEnabled(type: notification)
        cell.setup(type: notification, info: info, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource[indexPath.section]
        let notification = section.notifications[indexPath.row]
        
        selectedNotification = notification
        performSegue(withIdentifier: R.segue.notificationSettingsViewController.toNotificationDetails.identifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSource[section]
        return section.title
    }
}

// MARK: - Notification Settings Cell Delegate
extension NotificationSettingsViewController: NotificationSettingsCellDelegate {
    func enabledNotification(type: NotificationType, isEnabled: Bool) {
        if isEnabled {
            notificationService.setNotificationEnabled(type: type, isEnabled)
        } else {
            notificationService.setNotificationEnabled(type: type, isEnabled)
        }
    }
}

// MARK: - Enums to serve as data source for settings table view.
enum NotificationSettingsHeaders {
    case meals
    case weeklyUpdate
    
    var title: String {
        switch self {
        case .meals:
            return "Lembretes de refeição"
        case .weeklyUpdate:
            return "Lembretes de peso e meta"
        }
    }
    
    var notifications: [NotificationType] {
        switch self {
        case .meals:
            return [.addMealLunch, .addMealDinner]
        case .weeklyUpdate:
            return [.weeklyUpdate]
        }
    }
}
