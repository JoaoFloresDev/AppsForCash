//
//  DataLoaderTests.swift
//  AppTests
//
//  Created by Vinicius Hiroshi Higa on 22/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

@testable import My_Way
import XCTest
import CoreData

class MealAndDiaryTests: XCTestCase {

    var dataHandler: DataHandler?
    var meal: Meal?
    
    override func setUp() {
        
        do {
            self.dataHandler = try DataHandler.getShared()
        }
        catch {}
        
        meal = Meal(entity: NSEntityDescription.entity(forEntityName: "Meal", in:self.dataHandler!.managedContext)!, insertInto: self.dataHandler?.managedContext)
        meal?.setValue(1, forKey: "day")
        meal?.setValue(1, forKey: "month")
        meal?.setValue(2020, forKey: "year")
        meal?.setValue(1, forKey: "quality")
        meal?.setValue(15, forKey: "hour")
        meal?.setValue(30, forKey: "minute")
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidDate() {
        
        let date = Date()
        
        // Test
        // Gregorian calendar with future and past dates and leap years
        XCTAssert(try date.checkDate(year: 1800, month: 1, day: 1) == false)
        XCTAssert(try date.checkDate(year: 1900, month: 1, day: 1) == true)
        XCTAssert(try date.checkDate(year: 1900, month: 0, day: 1) == false)
        XCTAssert(try date.checkDate(year: 1900, month: 13, day: 1) == false)
        XCTAssert(try date.checkDate(year: 2077, month: 12, day: 1) == false)
        XCTAssert(try date.checkDate(year: 2000, month: 12, day: 1) == true)
        XCTAssert(try date.checkDate(year: 2012, month: 2, day: 29) == true)  // Leap Year
        XCTAssert(try date.checkDate(year: 2012, month: 2, day: 30) == false) // Leap Year
        XCTAssert(try date.checkDate(year: 2017, month: 2, day: 28) == true)  // Non-Leap Year
        XCTAssert(try date.checkDate(year: 2017, month: 2, day: 29) == false) // Non-Leap Year
        
    }
    
    func testDataCreation() {

        // Test 1
        // Adding a Diary without a Meal
        do {
            try self.dataHandler?.createDailyDiary(quality: 1, didDrinkWater: false, didPracticeExercise: false, didEatFruit: false)
            
            try self.dataHandler?.createDailyDiary(quality: 1, didDrinkWater: nil, didPracticeExercise: nil, didEatFruit: nil)
            
        }
        catch {
            XCTFail()
        }
        
        // Test 2
        // Adding a Diary with a Meal
        do {
            try self.dataHandler?.createDailyDiary(quality: 1, didDrinkWater: false, didPracticeExercise: false, didEatFruit: false, meal: self.meal!)
            
            try self.dataHandler?.createDailyDiary(quality: 1, didDrinkWater: nil, didPracticeExercise: nil, didEatFruit: nil, meal: self.meal!)
        }
        catch {
            XCTFail()
        }
        
        // Test 3
        // Adding a Diary with a Date and with Meal
        do {
            
            // ------------------------------------- //
            // PLEASE VERIFY THE DATE BEFORE TESTING //
            // ------------------------------------- //
            try self.dataHandler?.createDailyDiary(year: 2020, month: 4, day: 1, quality: -1, didDrinkWater: false, didPracticeExercise: false, didEatFruit: false, meal: self.meal!)
            
            try self.dataHandler?.createDailyDiary(year: 2020, month: 4, day: 23, quality: 1, didDrinkWater: nil, didPracticeExercise: nil, didEatFruit: nil, meal: self.meal!)
        }
        catch {
            XCTFail()
        }
        
        // Test 4
        // Adding a Meal
        do {
            try self.dataHandler?.createMeal(quality: 1, hour: 0, minute: 0)
        }
        catch  {
            XCTFail()
        }
        
        
    }
    
    func testDelete() {
        
        // Test 1
        // Removing a certain meal from a certain date
        do {
            
            // ------------------------------------- //
            // PLEASE VERIFY THE DATE BEFORE TESTING //
            // ------------------------------------- //
            try self.dataHandler?.deleteMeal(meal: self.meal!)
        }
        catch {
            XCTFail()
        }
        
        // Test 2
        // Removing all previous meals from certain date
        do {
            
            // ------------------------------------- //
            // PLEASE VERIFY THE DATE BEFORE TESTING //
            // ------------------------------------- //
            try self.dataHandler?.deleteAllMeals(year: 2020, month: 4, day: 23)
        }
        catch {
            XCTFail()
        }
        
    }
    
    func testDataLoad() {
        
        // Test 1
        // Checking if a Diary register exists in certain day
        do {
            
            // ------------------------------------- //
            // PLEASE VERIFY THE DATE BEFORE TESTING //
            // ------------------------------------- //
            let result = try self.dataHandler?.loadDailyDiary(year: 2020, month: 4, day: 23)
            print("Was found a register in day: \(String(describing: result!.day))")
        }
        catch {
            XCTFail()
        }
        
        
        // Test 2
        // Checking if a Meal register exists in certain day
        do {
            
            // ------------------------------------- //
            // PLEASE VERIFY THE DATE BEFORE TESTING //
            // ------------------------------------- //
            let result = try self.dataHandler?.loadMeals(year: 2020, month: 4, day: 23)
            print("Was found a register in day: \(String(describing: result![0].day))")
            
            //print("\n\n\n\n\n\n\(result)\n\n\n\n\n")
        }
        catch {
            XCTFail()
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
