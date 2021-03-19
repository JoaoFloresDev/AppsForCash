//
//  WeightTests.swift
//  AppTests
//
//  Created by Vinicius Hiroshi Higa on 07/05/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

@testable import My_Way
import XCTest
import CoreData

class WeightTests: XCTestCase {

    var dataHandler: DataHandler?
    
    override func setUp() {

        do {
            dataHandler = try DataHandler.getShared()
        }
        catch {}
        
    }


    func testCRUD() {
        
        // Test 1
        do {
            try self.create()
            try self.load()
            try self.delete()
        }
        catch {
            XCTFail()
        }
    }
    
    func testOnlyLoad() {
        
        do {
            try self.load()
        }
        catch {
            XCTFail()
        }
        
    }
    
    func testMultipleData() {
        do {
            
            try self.createMultipleData()
            let weights = try self.dataHandler?.loadWeight(year: 2020, month: 5)
            
            print("\n\n\n ------------- \n\n\n")
            print(weights?[0].day)
            print(weights?[1].day)
            
            print("\n\n\n ------------- \n\n\n")
            
        }
        catch {
            XCTFail()
        }
    }
    
    func create() throws {
        
        do {
            try self.dataHandler?.createWeight(value: 65, date: nil)
        }
        catch {
            throw error
        }
        
    }
    
    func createMultipleData() throws {
        
        do {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            let date1 = formatter.date(from: "2020/05/10 12:00")
            let date2 = formatter.date(from: "2020/05/09 12:00")
            let date3 = formatter.date(from: "2020/05/11 12:00")
            
            try self.dataHandler?.createWeight(value: 65, date: date1)
            try self.dataHandler?.createWeight(value: 65, date: date2)
            try self.dataHandler?.createWeight(value: 65, date: date3)
        }
        catch {
            throw error
        }
        
    }
    
    func loadMultipleData() throws {
        
        do {
            
            let weights = try self.loadMultipleData()
            
        }
        catch {
            throw error
        }
        
    }
    
    func load() throws {
        
        do {
            _ = try self.dataHandler?.loadWeight(year: 2020, month: 5, day: 8)
        }
        catch {
            throw error
        }
        
    }
    
    func delete() throws {
        
        do {
            try self.dataHandler?.deleteWeight(year: 2020, month: 5, day: 7)
        }
        catch {
            throw error
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
