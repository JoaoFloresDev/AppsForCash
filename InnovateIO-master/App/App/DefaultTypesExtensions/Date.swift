//
//  TimeInterval+HoursAndMinutes.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 22/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

extension Date {
    
    
    
    /// Gets all date information from today  (a.k.a Year, Month, Day, Hour, Minute and Second)
    /// - Returns: An optional tuple with the following order: Year, Month, Day, Hour, Minute and Second
    func getAllInformations() throws -> (Int, Int, Int, Int, Int, Int) {
        
        // Getting the User's calendar
        let calendar = Calendar.current
        
        // Mounting the request for the Calendar
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        
        // Getting the components from the Calendar
        let dateComponents = calendar.dateComponents(requestedComponents, from: self)
        
        // Checking for nils
        do {
            try self.hasNilComponents(on: dateComponents)
        }
        catch let error as DateError{
            throw error
        }
        
        // FIXED: Force unwrapped is checked now - Pull Request 11.
        return (dateComponents.year!, dateComponents.month!, dateComponents.day!,
                dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
        
    }
    
    /// Get amount of days available in certain year and month
    /// - Parameters:
    ///   - year: Desired year
    ///   - month: Desired month
    /// - Returns: The amount of days
    func getMaxDays(year: Int, month: Int) throws -> Int {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month)

        // Checking if Year and Month components inside DateComponents is nil
        if components.year == nil || components.month == nil {
            throw DateError.calendarNotFound
        }
        
        let date = calendar.date(from: components)
        let range = calendar.range(of: .day, in: .month, for: date!)
        
        return range!.count
        
    }
    
    
    
    /// Checks if a certain date exists from year 1900 and above (excluding the future).
    /// - Parameters:
    ///   - year: Desired year
    ///   - month: Desired month
    ///   - day: Desired day
    /// - Throws: Invalid calendar
    /// - Returns: If the day exists from year 1900 and above (excluding the future).
    func checkDate(year: Int, month: Int, day: Int) throws -> Bool {
        
        do {
            let (curYear, _, _, _, _, _) = try self.getAllInformations()
        
            if (year < 1900 || year > curYear) {
                return false
            }
            
            if (month < 1 || month > 12) {
                return false
            }
            
            do {
                let maxDays = try self.getMaxDays(year: year, month: month)
                
                if (day < 1 || day > maxDays) {
                    return false
                }
            }
            catch let error as DateError {
                throw error
            }
            
        }
        catch let error as DateError {
            throw error
        }
        
        return true
    }
    
    
    
    /// This is an aux function for these defined methods for converting from "type Date" into readable Date
    /// - Parameter dateComponents: The components to be checked
    /// - Throws: An Date Error for each component type
    private func hasNilComponents(on dateComponents: DateComponents) throws {
        
        if (dateComponents.year == nil) {
            throw DateError.emptyYear
        }
        
        if (dateComponents.month == nil) {
            throw DateError.emptyMonth
        }
        
        if (dateComponents.day == nil) {
            throw DateError.emptyDay
        }
        
        if (dateComponents.hour == nil) {
            throw DateError.emptyHour
        }
        
        if (dateComponents.minute == nil) {
            throw DateError.emptyMinute
        }
        
        if (dateComponents.second == nil) {
            throw DateError.emptySecond
        }
        
    }
    
    
    
    static func fromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)
    }
    
    func getAllDaysForWeek() -> [Date] {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: date)!
		let days = (weekdays.lowerBound+1 ... weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
        return days
    }
}
