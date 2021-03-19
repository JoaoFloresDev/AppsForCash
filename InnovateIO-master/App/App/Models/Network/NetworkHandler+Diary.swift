//
//  NetworkHandler+Diary.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 04/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import os.log

extension NetworkHandler {
    
    
    /// Creates a new Diary registry into iCloud.
    /// - Parameter diary: A diary instance with the date and it's attributes.
    func createDiary(diary: DailyDiary) throws {
        
        // Converting all values into Int with length of 64 bits
        let day: Int64 = Int64(diary.day)
        let month: Int64 = Int64(diary.month)
        let year: Int64 = Int64(diary.year)
        let quality: Int64 = Int64(diary.quality)
        
        var didDrinkWater: Int64 = 0
        var didEatFruit: Int64 = 0
        var didPracticeExercise: Int64 = 0
        
        if diary.didDrinkWater {
            didDrinkWater = 1
        }
        
        if diary.didEatFruit {
            didEatFruit = 1
        }
        
        if diary.didPracticeExercise {
            didPracticeExercise = 1
        }
        
        
        
        // Setting the values for the record
        let record = CKRecord(recordType: "DailyDiary")
        
        record.setValue(day, forKey: "day")
        record.setValue(month, forKey: "month")
        record.setValue(year, forKey: "year")
        record.setValue(quality, forKey: "quality")
        record.setValue(didDrinkWater, forKey: "didDrinkWater")
        record.setValue(didEatFruit, forKey: "didEatFruit")
        record.setValue(didPracticeExercise, forKey: "didPracticeExercise")
        
        
        
        // Checking if there is an old version of the record
        let (isThereOldRecord, ids) = self.existsPreviousDiary(diary: diary)
        
        if isThereOldRecord {
            // Delete previous one...
            
            ids.forEach({
                id in

                self.deletePreviousDiary(id: id)
                
            })
            
        }
        
        
        
        // Trying to save finally the data into the cloud...
        let semaphore = DispatchSemaphore(value: 0)
        var isRecordSaved = false
        
        self.container.privateCloudDatabase.save(record) { (_, error) in
            
            if error == nil {
                isRecordSaved = true
            }
            
            semaphore.signal()
            
        }
        
        semaphore.wait()
        
        if isRecordSaved == false {
            throw NetworkError.invalidParametersPassedIntoServer
        }
        
    }
    
    
    
    
    /// Checks if exists a previous entry data of a certain diary registry.
    /// - Parameter diary: A diary instance with the date and it's attributes.
    /// - Returns: A tuple saying if exists a previous data and the data itself as a list.
    private func existsPreviousDiary(diary: DailyDiary) -> (Bool, [CKRecord.ID]) {
        
        var isDiaryFound = false
        var ids: [CKRecord.ID] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        // Mounting the type of request
        let yearPredicate = NSPredicate(format: "year == \(Int64(diary.year))")
        let monthPredicate = NSPredicate(format: "month == \(Int64(diary.month))")
        let dayPredicate = NSPredicate(format: "day == \(Int64(diary.day))")
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate, dayPredicate])
        
        let query = CKQuery(recordType: "DailyDiary", predicate: predicate)
        
        
        // Searching for previous data in the database
        // WARNING! This is an async function... So we must use a semaphore...
        self.container.privateCloudDatabase.perform(query, inZoneWith: nil, completionHandler: {
            results, error in
            
            if let data = results {
                if data.count > 0 {
                    
                    // Getting all the previouds ids for that day
                    // OBS: For default should be just only 1, but if there was some error / misinformation
                    // we must delete all that previous
                    data.forEach({
                        record in
                        
                        ids.append(record.recordID)
                        
                    })
                    
                    isDiaryFound = true
                }
            }
            
            semaphore.signal()
            
            
        })
        
        semaphore.wait()
        return (isDiaryFound, ids)
        
    }
    
    
    
    
    /// Deletes some previous diary entry by passing it's ID.
    /// - Parameter id: The id of the diary in iCloud.
    private func deletePreviousDiary(id: CKRecord.ID) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Trying to delete previous data...
        // WARNING! This is an async function... So we must use a semaphore...
        self.container.privateCloudDatabase.delete(withRecordID: id, completionHandler: {
            _, _ in
            semaphore.signal()
        })
        
        semaphore.wait()
    }
    
}
