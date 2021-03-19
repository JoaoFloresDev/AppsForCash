//
//  DataLoader+Meal.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 22/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import CoreData


// An extension that handles the Diary's Data (DBO)
extension DataHandler {
    
    

    /// Creates a new Daily Diary entity and saves into the local storage.
    /// - Parameters:
    ///   - quality: Quality (between bad, neutral, good or in numbers -1, 0, 1)
    ///   - didDrinkWater: Did the user drink water
    ///   - didPracticeExercise: Did the user practice exercise / any sport
    ///   - didEatFruit: Did the user eat a fruit
    /// - Throws: Can't save into local storage due to available space is missing or corrupted or can't get the current date or invalid calendar or invalid entity.
    func createDailyDiary(quality: Int, didDrinkWater: Bool?, didPracticeExercise: Bool?, didEatFruit: Bool?) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "DailyDiary", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Getting the current date
        do {
            let date = Date()
            let (year, month, day, _, _, _) = try date.getAllInformations()
            
            // Checking for existing previous data
            do {
                let _ = try loadDailyDiary(year: year, month: month, day: day)
                try self.deleteDailyDiary(year: year, month: month, day: day)
            }
            catch { }
            
            // Clamping the quality variable
            var clampedQuality = 0
            
            if (quality < 0) {
                clampedQuality = -1
            }
            else if (quality > 0) {
                clampedQuality = 1
            }
            
            // Checking for optional variables
            var clampedDidDrinkWater = false
            var clampedDidPracticeExercise = false
            var clampedDidEatFruit = false
            
            if didDrinkWater != nil {
                clampedDidDrinkWater = didDrinkWater!
            }
            
            if didPracticeExercise != nil {
                clampedDidPracticeExercise = didPracticeExercise!
            }
            
            if didEatFruit != nil {
                clampedDidEatFruit = didEatFruit!
            }
            
            // Setting the values into context
            diary.setValue(clampedQuality, forKey: "quality")
            diary.setValue(year, forKey: "year")
            diary.setValue(month, forKey: "month")
            diary.setValue(day, forKey: "day")
            diary.setValue(clampedDidDrinkWater, forKey: "didDrinkWater")
            diary.setValue(clampedDidPracticeExercise, forKey: "didPracticeExercise")
            diary.setValue(clampedDidEatFruit, forKey: "didEatFruit")

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
    
    func createDailyDiaryInDate(quality: Int, didDrinkWater: Bool?, didPracticeExercise: Bool?, didEatFruit: Bool?, date: Date) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "DailyDiary", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Getting the current date
        do {
            let (year, month, day, _, _, _) = try date.getAllInformations()
            
            // Checking for existing previous data
            do {
                let _ = try loadDailyDiary(year: year, month: month, day: day)
                try self.deleteDailyDiary(year: year, month: month, day: day)
            }
            catch { }
            
            // Clamping the quality variable
            var clampedQuality = 0
            
            if (quality < 0) {
                clampedQuality = -1
            }
            else if (quality > 0) {
                clampedQuality = 1
            }
            
            // Checking for optional variables
            var clampedDidDrinkWater = false
            var clampedDidPracticeExercise = false
            var clampedDidEatFruit = false
            
            if didDrinkWater != nil {
                clampedDidDrinkWater = didDrinkWater!
            }
            
            if didPracticeExercise != nil {
                clampedDidPracticeExercise = didPracticeExercise!
            }
            
            if didEatFruit != nil {
                clampedDidEatFruit = didEatFruit!
            }
            
            // Setting the values into context
            diary.setValue(clampedQuality, forKey: "quality")
            diary.setValue(year, forKey: "year")
            diary.setValue(month, forKey: "month")
            diary.setValue(day, forKey: "day")
            diary.setValue(clampedDidDrinkWater, forKey: "didDrinkWater")
            diary.setValue(clampedDidPracticeExercise, forKey: "didPracticeExercise")
            diary.setValue(clampedDidEatFruit, forKey: "didEatFruit")

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
    
    /// Creates a new Daily Diary with a Meal entity and saves into the local storage.
    /// - Parameters:
    ///   - quality: Quality (between bad, neutral, good or in numbers -1, 0, 1)
    ///   - didDrinkWater: Did the user drink water
    ///   - didPracticeExercise: Did the user practice exercise / any sport
    ///   - didEatFruit: Did the user eat a fruit
    ///   - meal: The meal object if he/she wants to insert
    /// - Throws: Can't save into local storage due to available space is missing or corrupted or can't get the current date or invalid calendar or invalid entity.
    func createDailyDiary(quality: Int, didDrinkWater: Bool?, didPracticeExercise: Bool?, didEatFruit: Bool?, meal: Meal) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "DailyDiary", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Getting the current date
        do {
            let date = Date()
            let (year, month, day, _, _, _) = try date.getAllInformations()
        
            
            // Checking for existing previous data
            do {
                let _ = try loadDailyDiary(year: year, month: month, day: day)
                try self.deleteDailyDiary(year: year, month: month, day: day)
            }
            catch { } // If the catch got some exception... That means there is no previous data
            
            
            // Clamping the quality variable
            var clampedQuality = 0
            
            if (quality < 0) {
                clampedQuality = -1
            }
            else if (quality > 0) {
                clampedQuality = 1
            }
            
            
            // Checking for optional variables
            var clampedDidDrinkWater = false
            var clampedDidPracticeExercise = false
            var clampedDidEatFruit = false
            
            if didDrinkWater != nil {
                clampedDidDrinkWater = didDrinkWater!
            }
            
            if didPracticeExercise != nil {
                clampedDidPracticeExercise = didPracticeExercise!
            }
            
            if didEatFruit != nil {
                clampedDidEatFruit = didEatFruit!
            }
            
            // Setting the values into context
            diary.setValue(clampedQuality, forKey: "quality")
            diary.setValue(year, forKey: "year")
            diary.setValue(month, forKey: "month")
            diary.setValue(day, forKey: "day")
            diary.setValue(clampedDidDrinkWater, forKey: "didDrinkWater")
            diary.setValue(clampedDidPracticeExercise, forKey: "didPracticeExercise")
            diary.setValue(clampedDidEatFruit, forKey: "didEatFruit")

            // Trying to save the new data on local storage
            do {
                try self.managedContext.save()
            }
            catch {
                throw PersistenceError.cantSave
            }
        
            do {
                try self.createMeal(quality: Int(meal.quality), hour: Int(meal.hour), minute: Int(meal.minute))
            }
            catch {
                try self.deleteDailyDiary(year: year, month: month, day: day)
                throw PersistenceError.cantSave
            }
        }
        catch {
            throw DateError.calendarNotFound
        }
    }
    
    
    
    /// Creates a new Daily Diary with a Meal entity and saves into the local storage into a certain date.
    /// - Parameters:
    ///   - year: Desired Year
    ///   - month: Desired Month
    ///   - day: Desired Day
    ///   - quality: Quality (between bad, neutral, good or in numbers -1, 0, 1)
    ///   - didDrinkWater: Did the user drink water
    ///   - didPracticeExercise: Did the user practice exercise / any sport
    ///   - didEatFruit: Did the user eat a fruit
    ///   - meal: The meal object if he/she wants to insert
    /// - Throws: Can't save into local storage due to available space is missing or corrupted or can't get the current date or invalid calendar or invalid entity.
    func createDailyDiary(year: Int, month: Int, day: Int, quality: Int, didDrinkWater: Bool?, didPracticeExercise: Bool?, didEatFruit: Bool?, meal: Meal) throws {
        
        // Loading Core Data's User entity
        let entity = NSEntityDescription.entity(forEntityName: "DailyDiary", in: self.managedContext)
        
        // FIXED: Fixed force wrap by doing this verification and throwing an Exception - PR 11
        if entity == nil {
            throw PersistenceError.invalidEntity
        }
        
        let diary = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        // Checking if the desired date exists
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: day)
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
            
            
            // Checking for existing previous data
            do {
                let _ = try loadDailyDiary(year: year, month: month, day: day)
                try self.deleteDailyDiary(year: year, month: month, day: day)
            }
            catch { }
            
            
            // Clamping the quality variable
            var clampedQuality = 0
            
            if (quality < 0) {
                clampedQuality = -1
            }
            else if (quality > 0) {
                clampedQuality = 1
            }
            
            
            // Checking for optional variables
            var clampedDidDrinkWater = false
            var clampedDidPracticeExercise = false
            var clampedDidEatFruit = false
            
            if didDrinkWater != nil {
                clampedDidDrinkWater = didDrinkWater!
            }
            
            if didPracticeExercise != nil {
                clampedDidPracticeExercise = didPracticeExercise!
            }
            
            if didEatFruit != nil {
                clampedDidEatFruit = didEatFruit!
            }
            
            diary.setValue(clampedQuality, forKey: "quality")
            diary.setValue(year, forKey: "year")
            diary.setValue(month, forKey: "month")
            diary.setValue(day, forKey: "day")
            diary.setValue(clampedDidDrinkWater, forKey: "didDrinkWater")
            diary.setValue(clampedDidPracticeExercise, forKey: "didPracticeExercise")
            diary.setValue(clampedDidEatFruit, forKey: "didEatFruit")

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
    
    
    
    /// Loads a Daily Diary from the local storage.
    /// - Parameters:
    ///   - year: Desired year
    ///   - month: Desired month
    ///   - day: Desired day
    /// - Throws: Can't load from local storage because the data wasn't found or the date is invalid or invalid calendar.
    /// - Returns: A Daily Diary object from that Day
    func loadDailyDiary(year: Int, month: Int, day: Int) throws -> DailyDiary {
        
        // Checking if the date is valid
        do {
            let date = Date()
            let isValidDate = try date.checkDate(year: year, month: month, day: day)
            
            if !isValidDate {
                throw PersistenceError.invalidDate
            }
            
            // Mounting the type of request
            let fetchRequest = NSFetchRequest<DailyDiary>(entityName: "DailyDiary")

            let yearPredicate = NSPredicate(format: "year == %@", String(year))
            let monthPredicate = NSPredicate(format: "month == %@", String(month))
            let dayPredicate = NSPredicate(format: "day == %@", String(day))
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
            
            fetchRequest.predicate = predicate
            
            // Trying to find some User
            do {
                let dailyDiary = try managedContext.fetch(fetchRequest)
                
                if (dailyDiary.count == 0) {
                    throw PersistenceError.cantLoad
                }
                
                return dailyDiary[0]
            }
            catch {
                throw PersistenceError.cantLoad
            }
        }
        catch {
            throw DateError.calendarNotFound
        }

    }
    
    
    
    /// Deletes certain Daily Diary from the local storage
    /// - Parameters:
    ///   - year: Desired year
    ///   - month: Desired month
    ///   - day: Desired day
    /// - Throws: Can't load from local storage because the data wasn't found
    func deleteDailyDiary(year: Int, month: Int, day: Int) throws {
        
        // Mounting the type of request
        let fetchRequest = NSFetchRequest<DailyDiary>(entityName: "DailyDiary")

        let yearPredicate = NSPredicate(format: "year == %@", String(year))
        let monthPredicate = NSPredicate(format: "month == %@", String(month))
        let dayPredicate = NSPredicate(format: "day == %@", String(day))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
        
        fetchRequest.predicate = predicate
        
        // Trying to find some User
        do {
            let dailyDiary = try self.managedContext.fetch(fetchRequest)
            
            for result in dailyDiary {
                self.managedContext.delete(result)
            }
            
        }
        catch {
            throw PersistenceError.cantLoad
        }
        
    }
    
}
