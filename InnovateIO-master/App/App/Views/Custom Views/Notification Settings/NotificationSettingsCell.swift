//
//  NotificationSettingsCell.swift
//  App
//
//  Created by Priscila Zucato on 01/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit

protocol NotificationSettingsCellDelegate {
    func enabledNotification(type: NotificationType, isEnabled: Bool)
}

class NotificationSettingsCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var notificationType: NotificationType?
    var notificationInfo: NotificationInfoTuple?
    
    var delegate: NotificationSettingsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = selected ? .lightGray : .white
    }
    
    func setup(type: NotificationType, info: NotificationInfoTuple, delegate: NotificationSettingsCellDelegate) {
        self.delegate = delegate
        notificationType = type
        notificationInfo = info

        setTimeLabel()
        setInfoLabel()
    }
    
    private func setTimeLabel() {
        guard let hour = notificationInfo?.hour, let minute = notificationInfo?.minute else { return }
        
        timeLabel.text = String(format: "%02d:%02d", hour, minute)
    }
    
    private func setInfoLabel() {
        guard let weekdays = notificationInfo?.weekdays else { return }
        
        if weekdays == NotificationService.shared.arrayForAllWeekdays {
            infoLabel.text = "Todos os dias"
        } else {
            var weekdaysString = ""
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "pt-BR")
            
            for weekday in weekdays {
                weekdaysString = weekdaysString + formatter.shortWeekdaySymbols[weekday-1] + " "
            }
            infoLabel.text = weekdaysString
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        guard let type = self.notificationType else { return }
        delegate?.enabledNotification(type: type, isEnabled: sender.isOn)
    }
}
