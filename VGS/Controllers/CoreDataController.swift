//
//  CoreDataController.swift
//  VGS
//
//  Created by Huy Ong on 10/12/23.
//

import Foundation
import CoreData

class CoreDataController {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
}
