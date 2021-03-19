//
//  DataHandler+Meal.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 23/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import CoreData


// An extension that handles the Meal's Data (DBO)
extension DataHandler {
    
    
    /// Creates a new Meal information into the local storage by using the today's date.
    /// - Parameters:
    ///   - quality: Quality (between bad, neutral, good or in numbers -1, 0, 1)
    ///   - hour: The hour of the Meal
    ///   - minute: The minutes related to the hour of the Meal
    /// - Throws: Can't save into local storage due to available space is missing or corrupted or invalid time or invalid calendar or invalid entity.
    func createMeal(quality: Int, hour: Int, minute: Int, note: String? = nil) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "Meal", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Getting the current date
        do {
            let date = Date()
            let (year, month, day, _, _, _) = try date.getAllInformations()
            
            // Clamping the values if they were inserted incorrectly!
            var clampedQuality = 0
            
            if (quality < 0) {
                clampedQuality = -1
            }
            else if (quality > 0) {
                clampedQuality = 1
            }
            
            if (hour > 23) || (hour < 0) {
                throw PersistenceError.invalidTime
            }


            if (minute > 59) || (minute < 0) {
                throw PersistenceError.invalidTime
            }
         
            let id = UUID().uuidString
            
            // Setting the values into the Core Data's Model
            diary.setValue(id, forKey: "id")
            diary.setValue(clampedQuality, forKey: "quality")
            diary.setValue(year, forKey: "year")
            diary.setValue(month, forKey: "month")
            diary.setValue(day, forKey: "day")
            diary.setValue(hour, forKey: "hour")
            diary.setValue(minute, forKey: "minute")
            diary.setValue(note, forKey: "note")

            
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
    
    
    
    /// Creates a new Meal information into the local storage by inserting a desired date.
    /// - Parameters:
    ///   - quality: Quality (between bad, neutral, good or in numbers -1, 0, 1)
    ///   - year: Desired Year
    ///   - month: Desired Month
    ///   - day: Desired Day
    ///   - hour: The hour of the Meal
    ///   - minute: The minutes related to the hour of the Meal
    /// - Throws: Can't save into local storage due to available space is missing or corrupted or invalid date or invalid time or invalid calendar or invalid entity.
    func createMeal(quality: Int, year: Int, month: Int, day: Int, hour: Int, minute: Int, note: String? = nil) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "Meal", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)

        // Clamping the values if they were inserted incorrectly!
        var clampedQuality = 0
        
        if (quality < 0) {
            clampedQuality = -1
        }
        else if (quality > 0) {
            clampedQuality = 1
        }
        
        do {
            let isValidDate = try Date().checkDate(year: year, month: month, day: day)
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
        }
        catch {
            throw DateError.calendarNotFound
        }
        
        if (hour > 23) || (hour < 0) {
            throw PersistenceError.invalidTime
        }

        if (minute > 59) || (minute < 0) {
            throw PersistenceError.invalidTime
        }
        
        let id = UUID().uuidString
        
        // Setting the values into the Core Data's Model
        diary.setValue(id, forKey: "id")
        diary.setValue(clampedQuality, forKey: "quality")
        diary.setValue(year, forKey: "year")
        diary.setValue(month, forKey: "month")
        diary.setValue(day, forKey: "day")
        diary.setValue(hour, forKey: "hour")
        diary.setValue(minute, forKey: "minute")
        diary.setValue(note, forKey: "note")

        
        // Trying to save the new data on local storage
        do {
            try self.managedContext.save()
        }
        catch {
            throw PersistenceError.cantSave
        }
        
    }
    
    
    
    /// Loads the Meals datas from a desired Date
    /// - Parameters:
    ///   - year: Desired Year
    ///   - month: Desired Month
    ///   - day: Desired Day
    /// - Throws: Can't load storage data because it has invalid parameters or invalid calendar.
    /// - Returns: A list of meals registered in the certain Date.
    func loadMeals(year: Int, month: Int, day: Int) throws -> [Meal] {
        
        // Checking if the date is valid
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: day)
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
        }
        catch {
            throw DateError.calendarNotFound
        }
        
        // Mounting the type of request
        let fetchRequest = NSFetchRequest<Meal>(entityName: "Meal")

        let yearPredicate = NSPredicate(format: "year == %@", String(year))
        let monthPredicate = NSPredicate(format: "month == %@", String(month))
        let dayPredicate = NSPredicate(format: "day == %@", String(day))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
        
        fetchRequest.predicate = predicate
        
        // Trying to find some User
        do {
            let meals = try managedContext.fetch(fetchRequest)
            return meals
        }
        catch {
            throw PersistenceError.cantLoad
        }

    }
    
    
    
    /// Deletes a certain Meal by id.
    /// - Parameters:
    ///   - meal: The desired Meal (reference) to be removed
    /// - Throws: Can't load storage data because it has invalid parameters.
    func deleteMeal(mealID: String) throws {

        // Mounting the type of request
        let fetchRequest = NSFetchRequest<Meal>(entityName: "Meal")

        let idPredicate = NSPredicate(format: "id == %@", mealID)
        
        fetchRequest.predicate = idPredicate
        
        // Trying to find some User
        do {
            let meals = try managedContext.fetch(fetchRequest)
            
            for foundMeal in meals {
                managedContext.delete(foundMeal)
            }
        }
        catch {
            throw PersistenceError.cantLoad
        }
    }
    
    
    
    /// Deletes all Meals by passing a certain Date
    /// - Parameters:
    ///   - year: Desired Year
    ///   - month: Desired Month
    ///   - day: Desired Day
    /// - Throws: Can't load storage data because it has invalid parameters.
    func deleteAllMeals(year: Int, month: Int, day: Int) throws {
        
        // Checking if the date is valid
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: day)
                
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
        }
        catch {
            throw DateError.calendarNotFound
        }
        
        // Mounting the type of request
        let fetchRequest = NSFetchRequest<Meal>(entityName: "Meal")

        let yearPredicate = NSPredicate(format: "year == %@", String(year))
        let monthPredicate = NSPredicate(format: "month == %@", String(month))
        let dayPredicate = NSPredicate(format: "day == %@", String(day))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
        
        fetchRequest.predicate = predicate
        
        // Trying to find some User
        do {
            let meals = try managedContext.fetch(fetchRequest)
            
            for foundMeal in meals {
                managedContext.delete(foundMeal)
            }

        }
        catch {
            throw PersistenceError.cantLoad
        }
    }
}
