//
//  NetworkHandler.swift
//  App
//
//  Created by Vinicius Hiroshi Higa on 02/06/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class NetworkHandler {
    
    // Singleton related
    private static var shared: NetworkHandler?
    
    // Default properties related to iCloud
    private(set) var container: CKContainer
    
    
    /// Initializes the Singleton for handling the network and the iCloud.
    /// - Throws: An error that says the App wasn't fully initilized yet for managing data
    private init() throws {

        self.container = CKContainer(identifier: "iCloud.Innovate")
        
        // TODO: Por algum motivo não ta atualizando esse isContainer...
        // Mas para evitar perda de tempo... Eu estou considerando que o user já está logado...
//        var isContainerInitialized: Bool = false
//
//        self.container.accountStatus { status, _ in
//
//            print("[DEBUG] \(status == .available)")
//
//            if status == .available {
//                isContainerInitialized = true
//            }
//
//        }
//
//        // Checking if the container was found on the previous status
//        if isContainerInitialized == false { //I didn't put just !isContainerInitialized due to Clean Code practice
//            throw NetworkError.invalidContainer
//        }
        
        
    }
    
    
    
    /// Gets the shared instance of Network Handler.
    /// - Throws: An error that says the App wasn't fully initialized yet for managing data
    /// - Returns: A shared instance / singleton of Network Handler for managing iCloud's data
    static func getShared() throws -> NetworkHandler {
        
        if (NetworkHandler.shared == nil) {
            do {
                NetworkHandler.shared = try NetworkHandler()
            }
            catch let error as NetworkError {
                throw error
            }
        }
        
        return NetworkHandler.shared!
    }
}
