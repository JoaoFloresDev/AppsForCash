//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //        select root
        if (UserDefaults.standard.object(forKey: "FirtsUse") == nil) {
            print("1")
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            print("2")
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
            print("3")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // MARK: - Core Data stack
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "StoredImage")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
       
       // MARK: - Core Data Saving support
       
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}
