//
//  ServiceViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    var service: Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = service {
            nameTextField.text = c.name
            infoTextField.text = c.info
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        if saveService() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveService() -> Bool {
        if nameTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Service!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        if service == nil {
            service = Service()
        }
        
        if let c = service {
            c.name = nameTextField.text
            c.info = infoTextField.text
            CoreDataManager.shared.saveContext()
        }
        
        return true
    }

}
