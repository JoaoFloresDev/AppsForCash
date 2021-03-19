//
//  SettingsViewController.swift
//  App
//
//  Created by Priscila Zucato on 19/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import os.log

class SettingsViewController: UIViewController {

    @IBOutlet weak var optionsTableView: UITableView!
    
    let notificationService = NotificationService.shared
    
    var dataSource: [SettingsHeaders] = []
    
    /// This property dictates if notification switch is on/off, as well as if should show/hide notification settings cell.
    var isNotificationEnabled: Bool = false {
        didSet {
            notificationEnabledDidChange()
        }
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNotificationEnabled = self.notificationService.isNotificationEnabled

        setupTableView()
    }

// MARK: - Methods
    func setupTableView() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }
    
    fileprivate func notificationEnabledDidChange() {
        dataSource = [.tools(isNotificationEnabled), .tutorials, .about]
        
        DispatchQueue.main.async {
            if self.isNotificationEnabled {
                // This if clause make sure we are not inserting the cell if it already exists.
                if self.optionsTableView.numberOfRows(inSection: 0) < 3 {
                    self.optionsTableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            } else {
                // This if clause avoid crashes if table view hasn't inserted the row we want to delete here.
                if self.optionsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) != nil {
                    self.optionsTableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            }
        }
        
        notificationService.setIsEnabled(isNotificationEnabled)
    }
    
    func alertToSettings() -> UIAlertController {
        let alertController = UIAlertController(title: "Alerta", message: "Para ativar as notificações, vá às configurações do seu celular.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Configurações", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
// MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Implementar as segues para cada tipo de célula, quando necessário.
        
        switch segue.identifier {
        case SettingsCells.shareResults.segueId:
            if let destinationVC = segue.destination as? MealHistoryViewController {
                destinationVC.receivedDates = Date().getAllDaysForWeek()
                destinationVC.shouldShareWhenPresented = true
            }
        default:
            return
        }
    }
    
// MARK: - Actions
    @objc func notificationSwitchChanged(_ sender: UISwitch) {
        self.notificationService.notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.isNotificationEnabled = false
                DispatchQueue.main.async {
                    self.optionsTableView.reloadData()
                    let alert = self.alertToSettings()
                    self.present(alert, animated: true, completion: nil)
                }
            } else if settings.authorizationStatus == .denied {
                self.isNotificationEnabled = false
                DispatchQueue.main.async {
                    self.optionsTableView.reloadData()
                    let alert = self.alertToSettings()
                    self.present(alert, animated: true, completion: nil)
                }
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self.isNotificationEnabled = sender.isOn
                }
            }
        })
    }
}

// MARK: - Table View delegate and data source
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = dataSource[section]
        return section.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let section = dataSource[indexPath.section]
        let settingCell = section.cells[indexPath.row]
        cell.textLabel?.text = settingCell.title
        
        if settingCell == .enableNotifications {
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(isNotificationEnabled, animated: false)
            switchView.addTarget(self, action: #selector(self.notificationSwitchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSource[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource[indexPath.section]
        let settingCell = section.cells[indexPath.row]
        
        if let segueID = settingCell.segueId {
            performSegue(withIdentifier: segueID, sender: nil)
        }
        
        return
    }
}

// MARK: - Enums to serve as data source for settings table view.
enum SettingsHeaders {
    case tools(Bool)
    case tutorials
    case about
    
    var cells: [SettingsCells] {
        switch self {
        case .tools(let isNotificationOn):
            if isNotificationOn {
                return [.shareResults, .enableNotifications, .notificationSettings]
            } else {
                return [.shareResults, .enableNotifications]
            }
        case .tutorials:
            return [.howToUse, .healthyMeal]
        case .about:
            return [.about]
        }
    }
    
    var title: String {
        switch self {
        case .tools:
            return "Ferramentas"
        case .tutorials:
            return "Tutoriais"
        case .about:
            return "Sobre"
        }
    }
}

enum SettingsCells {
    case shareResults
    case enableNotifications
    case notificationSettings
    case howToUse
    case healthyMeal
    case about
    
    var title: String {
        switch self {
        case .shareResults:
            return "Compartilhar resultados"
        case .enableNotifications:
            return "Ativar notificações"
        case .notificationSettings:
            return "Horários de notificações"
        case .howToUse:
            return "Como utilizar"
        case .healthyMeal:
            return "Alimentação saudável"
        case .about:
            return "Sobre o aplicativo"
        }
    }
    
    var segueId: String? {
        switch self {
        case .shareResults:
            return R.segue.settingsViewController.toMealHistory.identifier
        case .notificationSettings:
            return R.segue.settingsViewController.toNotificationSettings.identifier
        case .healthyMeal:
            return R.segue.settingsViewController.toAboutMeal.identifier
        case .howToUse:
            return R.segue.settingsViewController.toHowToUse.identifier
        case .about:
            return R.segue.settingsViewController.toCredits.identifier
        default:
            return nil
        }
    }
}
