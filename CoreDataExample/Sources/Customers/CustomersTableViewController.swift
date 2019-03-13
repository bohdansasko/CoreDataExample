//
//  CustomersTableViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/12/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit
import CoreData

class CustomersTableViewController: UITableViewController {
    let kCustomerSegue = "customersToCustomer"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Customer> = CoreDataManager.shared.getFetchedResultsController(entityName: "Customer", sortKey: "name")
    
    typealias Select = (Customer?) -> ()
    var didSelect: Select?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCustomersFromDB()
    }
    
    @IBAction func handleActionAddCustomer(_ sender: Any) {
        performSegue(withIdentifier: kCustomerSegue, sender: nil)
    }
    
    func fetchCustomersFromDB() {
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
        let customer = fetchedResultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = customer.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let customer = fetchedResultsController.object(at: indexPath)
        if let didSelect = self.didSelect {
            didSelect(customer)
            navigationController?.popViewController(animated: true)
        } else {
            performSegue(withIdentifier: kCustomerSegue, sender: customer)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kCustomerSegue {
            guard let navControl = segue.destination as? UINavigationController,
                  let customerVC = navControl.topViewController as? CustomerViewController else { return }
            customerVC.customer = sender as? Customer
        }
    }

}

extension CustomersTableViewController: NSFetchedResultsControllerDelegate {
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
            let customer = fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.delete(managedObj: customer)
            CoreDataManager.shared.saveContext()
        }
    }
}
