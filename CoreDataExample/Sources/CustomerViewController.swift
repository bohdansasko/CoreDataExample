//
//  CustomerViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/12/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    var customer: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let c = customer {
            nameTextField.text = c.name
            infoTextField.text = c.info
        }
    }

    @IBAction func save(sender: AnyObject) {
        if saveCustomer() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveCustomer() -> Bool {
        if nameTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Customer!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        if customer == nil {
            customer = Customer()
        }
        
        if let c = customer {
            c.name = nameTextField.text
            c.info = infoTextField.text
            CoreDataManager.shared.saveContext()
        }
        
        return true
    }
    
}
