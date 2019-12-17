//
//  CoreDataManager.swift
//  CoredataPOC
//
//  Created by Wipro on 11/12/19.
//  Copyright © 2019 wipro. All rights reserved.
//

import UIKit
import CoreData
//protocol serviceProtocols {
//    func fetchList(completionHandler: @escaping (() throws -> [Users]) -> Void)
//}

final class CoreDataManager: NSObject {
    // MARK: - Properties
    typealias CompletionHandler = (_ responce: AnyObject) -> Void
    static let sharedInstance = CoreDataManager()

   // var modelName: String = "CoredataPOC"
    
    // MARK: - Initialization
    
//   private init(modelName: String) {
//        self.modelName = modelName
//    }
    
    // MARK: - Core Data Stack
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "CoredataPOC", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "CoredataPOC.sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    func fetchList(completionHandler: @escaping CompletionHandler) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CUser")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            var userObj = [CUsers]()
            
            for resultObj in results as! [NSManagedObject] {
                //userObj.append(resultObj as! CUsers)
            }
            completionHandler(userObj as AnyObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func createUser(userData: CUsers, compleationHandler: @escaping CompletionHandler) {
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "CUser", in: managedObjectContext)
        
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            let list = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
            list.setValue(userData.first_name, forKey: "first_name")
            list.setValue(userData.first_name, forKey: "last_name")
            list.setValue(userData.email, forKey: "email")
            
            print(list)
            
            do {
                // Save Changes
                try managedObjectContext.save()
                compleationHandler("Success" as AnyObject)
                
                
            } catch {
                // Error Handling
            }
        }
    }
}
