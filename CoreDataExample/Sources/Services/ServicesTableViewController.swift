//
//  ServicesTableViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit
import CoreData

class ServicesTableViewController: UITableViewController {
    let kServiceSegue = "servicesToService"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Service> = CoreDataManager.shared.getFetchedResultsController(entityName: "Service", sortKey: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchServicesFromDB()
    }
    
    @IBAction func handleActionAddService(_ sender: Any) {
        performSegue(withIdentifier: kServiceSegue, sender: nil)
    }
    
    func fetchServicesFromDB() {
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch (let err) {
            print(err)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sec = fetchedResultsController.sections {
            return sec[section].numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = fetchedResultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = service.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: kServiceSegue, sender: service)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kServiceSegue {
            guard let navControl = segue.destination as? UINavigationController,
                let serviceVC = navControl.topViewController as? ServiceViewController else { return }
            serviceVC.service = sender as? Service
        }
    }
}

extension ServicesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let idxPath = newIndexPath {
                tableView.insertRows(at: [idxPath], with: .automatic)
            }
        case .update:
            if let idxPath = indexPath {
                let customer = fetchedResultsController.object(at: idxPath)
                let cell = tableView.cellForRow(at: idxPath)
                cell?.textLabel?.text = customer.name
            }
        case .move:
            if let idxPath = indexPath {
                tableView.deleteRows(at: [idxPath], with: .automatic)
            }
            
            if let idxPath = newIndexPath {
                tableView.insertRows(at: [idxPath], with: .automatic)
            }
        case .delete:
            if let idxPath = indexPath {
                tableView.deleteRows(at: [idxPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let service = fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.delete(managedObj: service)
            CoreDataManager.shared.saveContext()
        }
    }
}
