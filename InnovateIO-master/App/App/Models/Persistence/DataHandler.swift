//
//  DataLoader.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 07/04/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import UIKit
import CoreData

class DataHandler {
    
    // Singleton related
    private static var shared: DataHandler?
    
    // Default properties related to the DAO (DataLoader)
    private(set) var managedContext: NSManagedObjectContext
    
    
    /// Initializes the Singleton with the "ScratchPad" (Managed Object Context) for loading and saving data in the iOS  internal Database.
    /// - Throws: An error that says the App wasn't fully initilized yet for managing data
    private init() throws {

        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            throw PersistenceError.applicationNotRunning
        }

        self.managedContext = appDelegate.persistentContainer.viewContext
        
        
    }
    
    
    
    /// Gets the shared instance of DataLoader.
    /// - Throws: An error that says the App wasn't fully initialized yet for managing data
    /// - Returns: A shared instance / singleton of DataLoader for managing data
    static func getShared() throws -> DataHandler {
        
        if (DataHandler.shared == nil) {
            do {
                DataHandler.shared = try DataHandler()
            }
            catch let error as PersistenceError {
                throw error
            }
        }
        
        return DataHandler.shared!
    }
    
}
