//
//  PersonController.swift
//  Pair
//
//  Created by Nicholas Ellis on 1/20/17.
//  Copyright © 2017 Nicholas Ellis. All rights reserved.
//

import Foundation
import CoreData

class PersonController {
    static let sharedController = PersonController()
    let fetchedResultsController: NSFetchedResultsController<Person>
    
    init() {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let completedSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [completedSortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                   managedObjectContext: CoreDataStack.context,
                                                                   sectionNameKeyPath: "name",
                                                                   cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch request: \(error)")
        }
        
    }
    
    
    func addPerson(name: String) {
        let _ = Person(name: name)
        saveToPersistentStorage()
    }
    
    func removePerson(name: Person) {
        name.managedObjectContext?.delete(name)
        saveToPersistentStorage()
    }

    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("There was an error")
        }
    }
}

