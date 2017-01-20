//
//  PairViewController.swift
//  Pair
//
//  Created by Nicholas Ellis on 1/20/17.
//  Copyright © 2017 Nicholas Ellis. All rights reserved.
//
import UIKit
import CoreData
import UserNotifications
import GameKit

class PairViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.sharedController.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = PersonController.sharedController.fetchedResultsController.sections else { return 0 }
        return sections.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = PersonController.sharedController.fetchedResultsController.sections else {
            return 2 }
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let person = PersonController.sharedController.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = PersonController.sharedController.fetchedResultsController.object(at: indexPath)
            PersonController.sharedController.removePerson(name: person)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \([section + 1][0])"
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var personNameTextFieled: UITextField?
        let alert = UIAlertController(title: "Enter Full Name", message: "Pair Randomizer", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Full Name.."
            personNameTextFieled = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            (textField) in
            guard let nameText = personNameTextFieled?.text else { return }
            PersonController.sharedController.addPerson(name: nameText)
            
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        guard let fetchObjects = PersonController.sharedController.fetchedResultsController.fetchedObjects else { return }
        let _ = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: fetchObjects)
        //// MARK: - finish randomizing the persons then put onto cell
    }
}
