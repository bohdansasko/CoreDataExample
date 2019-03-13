//
//  OrdersTableViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit
import CoreData

class OrdersTableViewController: UITableViewController {

    let kOrderSegue = "ordersToOrder"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Order> = CoreDataManager.shared.getFetchedResultsController(entityName: "Order", sortKey: "date")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOrdersFromDB()
    }
    
    @IBAction func handleActionAddOrder(_ sender: Any) {
        performSegue(withIdentifier: kOrderSegue, sender: nil)
    }
    
    func fetchOrdersFromDB() {
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
        let order = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        
        configCell(cell: cell, order: order)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: kOrderSegue, sender: order)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kOrderSegue {
            guard let navControl = segue.destination as? UINavigationController,
                let orderVC = navControl.topViewController as? OrderViewController else { return }
            orderVC.order = sender as? Order
        }
    }
    
    func configCell(cell: UITableViewCell, order: Order) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let nameOfCustomer = (order.customer == nil) ? "-- Unknown --" : (order.customer!.name!)
        cell.textLabel?.text = formatter.string(from: (order.date as Date?)!) + "\t" + nameOfCustomer
    }
}

extension OrdersTableViewController: NSFetchedResultsControllerDelegate {
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
                let order = fetchedResultsController.object(at: idxPath)
                let cell = tableView.cellForRow(at: idxPath)
                cell?.textLabel?.text = order.customer?.name
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
            let order = fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.delete(managedObj: order)
            CoreDataManager.shared.saveContext()
        }
    }
}
