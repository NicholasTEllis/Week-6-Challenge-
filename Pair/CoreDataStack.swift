//
//  CoreDataStack.swift
//  Pair
//
//  Created by Nicholas Ellis on 1/20/17.
//  Copyright © 2017 Nicholas Ellis. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Person")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
            
        })
        
        return container
        
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    
}
