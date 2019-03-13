//
//  OrderViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {
    enum SeguesId: String {
        case orderToCustomers
        case orderToRowOfOrder
    }
    
    var order: Order?
    var dataSource: NSFetchedResultsController<RowOfOrder>?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var switchMade: UISwitch!
    @IBOutlet weak var switchPaid: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOrderModel()
        setupViews()
        fetchOrderRowsFromDB()
    }
    
    func setupOrderModel() {
        if order == nil {
            order = Order()
            order?.date = NSDate()
        }
    }
    
    func setupViews() {
        tableView.dataSource = self
        
        if let order = order {
            datePicker.date = order.date! as Date
            switchMade.isOn = order.made
            switchPaid.isOn = order.paid
            customerTextField.text = order.customer?.name
        }
    }
    
    func fetchOrderRowsFromDB() {
        dataSource = order!.getRowsOfOrder(order: order!)
        dataSource?.delegate = self
        do {
            try dataSource!.performFetch()
        } catch (let err) {
            print(err)
        }
    }
    
    @IBAction func save(sender: Any) {
        if saveOrder() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceCustomer(sender: AnyObject) {
        // performSegue(withIdentifier: kSegueOrderToCustomers, sender: nil)
    }
    
    @IBAction func addRowOfOrder(_ sender: Any) {
        if let order = order {
            let newRow = RowOfOrder()
            newRow.order = order
            performSegue(withIdentifier: SeguesId.orderToRowOfOrder.rawValue, sender: newRow)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesId.orderToCustomers.rawValue {
            guard let destVC = segue.destination as? CustomersTableViewController else {
                return
            }
            destVC.didSelect = { [unowned self] (customer) in
                if let customer = customer {
                    self.order?.customer = customer
                    self.customerTextField.text = customer.name
                }
            }
        } else if segue.identifier == SeguesId.orderToRowOfOrder.rawValue {
            guard let navigController = segue.destination as? UINavigationController,
                  let destVC = navigController.topViewController as? RowOfOrderViewController  else {
                return
            }
            destVC.rowOfOrder = sender as? RowOfOrder
        }
    }
    
    func saveOrder() -> Bool {
        if let order = order {
            order.date = datePicker.date as NSDate
            order.made = switchMade.isOn
            order.paid = switchPaid.isOn
            CoreDataManager.shared.saveContext()
        }
        
        return order != nil
    }
    
    
    
}

extension OrderViewController: UITableViewDataSource {
    // MARK - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sec = dataSource?.sections {
            return sec[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowOfOrder = dataSource?.object(at: indexPath) else { return UITableViewCell() }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = (rowOfOrder.service?.name ?? "- ") + " - " + String(rowOfOrder.sum)
        return cell
    }
}

extension OrderViewController: NSFetchedResultsControllerDelegate {
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
                guard let rowOfOrder = dataSource?.object(at: idxPath),
                      let cell = tableView.cellForRow(at: idxPath) else { return }
                cell.textLabel?.text = (rowOfOrder.service?.name ?? "- ") + " - " + String(rowOfOrder.sum)
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
