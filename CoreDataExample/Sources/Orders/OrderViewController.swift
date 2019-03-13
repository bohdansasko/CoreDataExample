//
//  OrderViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    var order: Order?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var switchMade: UISwitch!
    @IBOutlet weak var switchPaid: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(sender: AnyObject) {
        if saveOrder() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveOrder() -> Bool {
        return true
    }
}
