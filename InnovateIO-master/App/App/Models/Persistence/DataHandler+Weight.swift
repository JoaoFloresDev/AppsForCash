//
//  DataHandler+Weight.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 07/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import CoreData
import os.log


extension DataHandler {
    
    
    /// Creates a weight registry into the local storage by using the today's date or given date.
    /// - Parameters:
    ///   - value: The value of the weight.
    ///   - date: (Optional) The value of a date to be inserted.
    /// - Throws: An invalid entity error or no space available on local storage.
    func createWeight(value: Float, date: Date?) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "Weight", in: self.managedContext)
        
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let weight = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Getting the current date...
        do {
            
            var dateToConvert: Date = Date()
            
            // Checking if we can use the user's date...
            if date != nil {
                dateToConvert = date!
            }
            
            let (year, month, day, _, _, _) = try dateToConvert.getAllInformations()
            

            // Checking for existing previous data
            do {
                let _ = try loadWeight(year: year, month: month, day: day)
                try self.deleteWeight(year: year, month: month, day: day)
            }
            catch {
                os_log("[CORE DATA] No data found related to the current date!", [])
            }
            
            
            // Setting the values into context
            weight.setValue(value, forKey: "value")
            weight.setValue(year, forKey: "year")
            weight.setValue(month, forKey: "month")
            weight.setValue(day, forKey: "day")
            
            // Trying to save the new data on local storage
            do {
                try self.managedContext.save()
            }
            catch {
                throw PersistenceError.cantSave
            }
        }
        catch {
            throw DateError.calendarNotFound
        }

        
    }
    
    
    
    /// Loads a weight entity from the local storage into the memory.
    /// - Parameters:
    ///   - year: Year to be checked
    ///   - month: Month to be checked
    ///   - day: Day to be checked
    /// - Throws: Can't load from local storage because the data wasn't found or the date is invalid or invalid calendar.
    /// - Returns: A Weight Entity from certain day.
    func loadWeight(year: Int, month: Int, day: Int) throws -> Weight {
        
        // Checking if the date is valid
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: day)
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
            
            // Mounting the type of request
            let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")

            let yearPredicate = NSPredicate(format: "year == %@", String(year))
            let monthPredicate = NSPredicate(format: "month == %@", String(month))
            let dayPredicate = NSPredicate(format: "day == %@", String(day))
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
            
            fetchRequest.predicate = predicate
            
            // Trying to find some User
            do {
                let weights = try managedContext.fetch(fetchRequest)
                
                if (weights.count == 0) {
                    throw PersistenceError.cantLoad
                }
                
                return weights[0]
            }
            catch {
                throw PersistenceError.cantLoad
            }
        }
        catch {
            throw DateError.calendarNotFound
        }

    }
    
    
    
    /// Loads a weight entities multiple times from a given month and year  from the local storage into the memory.
    /// - Parameters:
    ///   - year: Year to be checked
    ///   - month: Month to be checked
    /// - Throws: Can't load from local storage because the data wasn't found or the date is invalid or invalid calendar.
    /// - Returns: A Weight Entity from certain day.
    func loadWeight(year: Int, month: Int) throws -> [Weight] {
        
        // Checking if the date is valid
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: 1) // Workaround for day...
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
            
            // Mounting the type of request
            let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")

            let yearPredicate = NSPredicate(format: "year == %@", String(year))
            let monthPredicate = NSPredicate(format: "month == %@", String(month))
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
            
            fetchRequest.predicate = predicate
            
            // Trying to find some User
            do {
                let weights = try managedContext.fetch(fetchRequest)
                
                if (weights.count == 0) {
                    throw PersistenceError.cantLoad
                }
                
                return weights
            }
            catch {
                throw PersistenceError.cantLoad
            }
        }
        catch {
            throw DateError.calendarNotFound
        }

    }
    
    

    /// Deletes a Weight registry in local storage.
    /// - Parameter date: The date that must be checked
    /// - Throws: Can't load from local storage because the data wasn't found or the date is invalid.
    func deleteWeight(year: Int, month: Int, day: Int) throws {
        
        // Mounting the type of request
        let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")

        let yearPredicate = NSPredicate(format: "year == %@", String(year))
        let monthPredicate = NSPredicate(format: "month == %@", String(month))
        let dayPredicate = NSPredicate(format: "day == %@", String(day))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
        
        fetchRequest.predicate = predicate
        
        // Trying to find some User
        do {
            let weights = try self.managedContext.fetch(fetchRequest)
            
            for result in weights {
                self.managedContext.delete(result)
            }
            
        }
        catch {
            throw PersistenceError.cantLoad
        }
        
    }
    
}
