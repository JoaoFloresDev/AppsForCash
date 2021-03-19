//
//  NotificationService.swift
//  App
//
//  Created by Priscila Zucato on 23/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import os.log

typealias NotificationInfoTuple = (weekdays: [Int], hour: Int, minute: Int)

class NotificationService {
    static let shared = NotificationService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private let userKeyForEnabled = "isNotificationEnabled"
    private let userKeyForSetOnce = "wasSetOnce"
    
    private let userInfoTypeKey = "notificationType"
    private let userDefaults = UserDefaults.standard
    
    /// Week starting on Monday.
    let arrayForAllWeekdays = [2,3,4,5,6,7,1]
    
    /// Getter for value saved in user defaults.
    var isNotificationEnabled: Bool {
        get {
            userDefaults.bool(forKey: userKeyForEnabled)
        }
    }
    var wasOnceSet: Bool {
        get {
            userDefaults.bool(forKey: userKeyForSetOnce)
        }
    }
    
// MARK: - Notifications permissions
    /// Request user's permission to fire notifications.
    func requestPermissions() {
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: notificationOptions) {[weak self] isAllowed, error in
            guard let self = self else { return }
            if error != nil {
                os_log("Notification Error: ", error! as CVarArg)
                self.setIsEnabled(false)
            } else {
                if !self.wasOnceSet {
                    self.setInitialValues()
                    self.setIsEnabled(isAllowed)
                }
            }
        }
    }
    
// MARK: - Sending or removing notifications
    
    /// Creates a notification content, its trigger and its request to add to notification center, according to the type of the notification.
    /// - Parameter type: type of notification.
    private func sendNotification(type: NotificationType) {
        if getNotificationIsEnabled(type: type) {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Não se esqueça!"
            notificationContent.body = type.body
            notificationContent.userInfo = [userInfoTypeKey : type.rawValue]
            
            var dateComponent = DateComponents()
            
            let (weekdays, hour, minute) = getNotificationSettings(for: type)
            
            for weekday in weekdays {
                let uniqueIdentifier = type.rawValue + String(weekday)
                
                dateComponent.weekday = weekday
                dateComponent.hour = hour
                dateComponent.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                
                let request = UNNotificationRequest(identifier: uniqueIdentifier,
                                                    content: notificationContent,
                                                    trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        os_log("Notification Error: ", error as CVarArg)
                    }
                }
            }
        }
    }
    
    /// Removes all delivered and pending notifications for designated notification type and weekdays.
    private func disableAllNotifications(for type: NotificationType) {
        var identifiers: [String] = []
        let weekdays = getNotificationSettings(for: type).weekdays
        for weekday in weekdays {
            let uniqueIdentifier = type.rawValue + String(weekday)
            identifiers.append(uniqueIdentifier)
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    /// Removes all delivered and pending notifications from notification center.
    private func disableAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
// MARK: - Saving or getting data to/from User Defaults.
    
    func setInitialValues() {
        setNotificationEnabled(type: .addMealLunch, true)
        setNotificationEnabled(type: .addMealDinner, true)
        setNotificationEnabled(type: .weeklyUpdate, true)
        
        userDefaults.set(true, forKey: userKeyForSetOnce)
    }
    
    /// Empties saved values on User Defaults (not sure if necessary/convenient).
    private func clearSpace() {
        userDefaults.set(nil, forKey: NotificationType.addMealLunch.rawValue)
        userDefaults.set(nil, forKey: NotificationType.addMealDinner.rawValue)
        userDefaults.set(nil, forKey: NotificationType.weeklyUpdate.rawValue)
    }
    
    /// Saves notification configurations to user defaults and updates notifications to be sent on notification center.
    func persistNotificationSettings(notificationType: NotificationType, notificationInfo: NotificationInfoTuple) {
        disableAllNotifications(for: notificationType)
        
        var info = notificationInfo
        info.weekdays = orderWeekdays(weekdays: notificationInfo.weekdays)
        let dict = notificationTupleToDictionary(tuple: info)
        userDefaults.set(dict, forKey: notificationType.rawValue)
        
        sendNotification(type: notificationType)
    }
    
    private func orderWeekdays(weekdays: [Int]) -> [Int] {
        // Removing elements that don't represent weekdays
        var sortedWeekdays = weekdays.filter { (int) -> Bool in
            return int < 8 && int > 0
        }
        // Removing duplicates
        sortedWeekdays = Array(Set(sortedWeekdays))
        // Sorting
        sortedWeekdays.sort()
        // Remove 1 from array and adds it to the end of the list.
        if sortedWeekdays.contains(1) {
            sortedWeekdays.removeFirst(1)
            sortedWeekdays.append(1)
        }
        
        return sortedWeekdays
    }
    
    private func notificationTupleToDictionary(tuple: NotificationInfoTuple) -> [String: Any] {
        return ["weekdays": tuple.weekdays,
                "hour": tuple.hour,
                "minute": tuple.minute]
    }
    
    private func dictToNotificationTuple(dictionary: [String: Any]) -> NotificationInfoTuple? {
        guard let weekdays = dictionary["weekdays"] as? [Int],
            let hour = dictionary["hour"] as? Int,
            let minute = dictionary["minute"] as? Int else {
                return nil
        }
        return (weekdays: weekdays, hour: hour, minute: minute)
    }
    
    /// Will update value for isNotificationEnabled on User Defaults. If true, will send notifications; if false, will remove notifications and clear other saved data on User Defaults.
    func setIsEnabled(_ value: Bool) {
        userDefaults.set(value, forKey: userKeyForEnabled)
        if value {
            sendNotification(type: .addMealLunch)
            sendNotification(type: .addMealDinner)
            sendNotification(type: .weeklyUpdate)
        } else {
            clearSpace()
            disableAllNotifications()
        }
    }
    
    func setNotificationEnabled(type: NotificationType, _ value: Bool) {
        userDefaults.set(value, forKey: type.rawValue + "isEnabled")
        if value {
            sendNotification(type: type)
        } else {
            disableAllNotifications(for: type)
        }
    }
    
    func getNotificationIsEnabled(type: NotificationType) -> Bool {
        return userDefaults.bool(forKey: type.rawValue + "isEnabled")
    }
    
    /// Will return a tuple containing the set information for the type of notification.
    func getNotificationSettings(for type: NotificationType) -> NotificationInfoTuple {
        guard let dict = userDefaults.dictionary(forKey: type.rawValue) else {
            return type.defaultConfig
        }
        let tuple = dictToNotificationTuple(dictionary: dict)
        return tuple ?? type.defaultConfig
    }
    
// MARK: - Navigation
    
    /// Use this to make appropriate navigations inside app depending on type of notification.
    /// - Parameters:
    ///   - userInfo: userInfo dictionary associated with notification.
    ///   - rootVC: the root view controller, which is a tab bar controller.
    func handleNavigation(for userInfo: [AnyHashable : Any], rootVC: UITabBarController) {
        guard let typeID = userInfo[userInfoTypeKey] as? String else {
            os_log("Couldn't handle user info for notification.")
            return
        }
        
        guard let type = NotificationType(rawValue: typeID) else { return }
        
        switch type {
        case NotificationType.addMealLunch, NotificationType.addMealDinner:
            rootVC.selectedViewController = rootVC.viewControllers?.first(where: { (viewController) -> Bool in
                return viewController.restorationIdentifier == "MealNavigationViewController"
            })
            
        case NotificationType.weeklyUpdate:
            guard let profileVC = rootVC.selectedViewController as? ProfileViewController else { return }
            profileVC.performSegue(withIdentifier: R.segue.profileViewController.toEditData.identifier, sender: nil)
        default: return
            
        }
    }
}

// MARK: - Notification Types enum
enum NotificationType: String {
    case addMealLunch = "addMealLunch"
    case addMealDinner = "addMealDinner"
    case weeklyUpdate = "weeklyUpdate"
    
    var body: String {
        switch self {
        case .addMealLunch, .addMealDinner:
            return "Não se esqueça de marcar sua refeição!"
        case .weeklyUpdate:
            return "Que tal atualizar seu peso e meta?"
        }
    }
    
    var defaultConfig: NotificationInfoTuple {
        switch self {
        case .addMealLunch:
            return (NotificationService.shared.arrayForAllWeekdays, 12, 0)
        case .addMealDinner:
            return (NotificationService.shared.arrayForAllWeekdays, 20, 0)
        case .weeklyUpdate:
            return ([1], 12, 0)
        }
    }
}
