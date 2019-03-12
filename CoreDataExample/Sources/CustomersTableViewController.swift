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

    lazy var fetchedResultsController: NSFetchedResultsController<Customer> = CoreDataManager.shared.getFetchedResultsController(entityName: "Customer", sortKey: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCustomersFromDB()
    }
    
    func fetchCustomersFromDB() {
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
