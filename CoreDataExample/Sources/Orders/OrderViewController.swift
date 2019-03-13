//
//  OrderViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    let kSegueOrderToCustomers = "orderToCustomers"
    
    var order: Order?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var switchMade: UISwitch!
    @IBOutlet weak var switchPaid: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if order == nil {
            order = Order()
            order?.date = NSDate()
        }
        
        if let order = order {
            datePicker.date = order.date! as Date
            switchMade.isOn = order.made
            switchPaid.isOn = order.paid
            customerTextField.text = order.customer?.name
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        if saveOrder() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceCustomer(sender: AnyObject) {
        // performSegue(withIdentifier: kSegueOrderToCustomers, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueOrderToCustomers {
            guard let destVC = segue.destination as? CustomersTableViewController else {
                return
            }
            destVC.didSelect = { [unowned self] (customer) in
                if let customer = customer {
                    self.order?.customer = customer
                    self.customerTextField.text = customer.name
                }
            }
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
