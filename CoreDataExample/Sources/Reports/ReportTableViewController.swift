//
//  ReportTableViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit
import CoreData

class ReportTableViewController: UITableViewController {

    var datasource: NSFetchedResultsController<Order>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = buildDatasource()
        datasource.delegate = self
        do {
            try datasource.performFetch()
        } catch (let err) {
            print(err)
        }
    }
    
    func buildDatasource() -> NSFetchedResultsController<Order> {
        let fetchRequest = NSFetchRequest<Order>(entityName: "Order")
        
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "customer.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]

        let predicate = NSPredicate(format: "%K == %@ AND %K = %@", argumentArray: ["made", true, "paid", false])
        fetchRequest.predicate = predicate
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dsSection = datasource.sections?[section] {
            return dsSection.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = datasource.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = order.customer?.name
        return cell
    }

}

extension ReportTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let idxPath = newIndexPath {
                tableView.insertRows(at: [idxPath], with: .automatic)
            }
        case .update:
            if let idxPath = indexPath {
                let order = datasource.object(at: idxPath)
                guard let cell = tableView.cellForRow(at: idxPath) else {
                    return
                }
                cell.textLabel?.text = order.customer?.name
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
}
