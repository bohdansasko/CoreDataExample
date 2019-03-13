//
//  RowOfOrderViewController.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/13/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import UIKit

class RowOfOrderViewController: UIViewController {
    let kSegueOrderToService = "orderToService"
    
    var rowOfOrder: RowOfOrder?
    
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rowOfOrder = rowOfOrder, rowOfOrder.service != nil else { return }
        serviceTextField.text = rowOfOrder.service?.name
        sumTextField.text = String(rowOfOrder.sum)
    }
    
    @IBAction func save(sender: AnyObject) {
        if saveOrder() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleChoiceAction(sender: AnyObject) {
        performSegue(withIdentifier: kSegueOrderToService, sender: nil)
    }

    func saveOrder() -> Bool {
        rowOfOrder?.sum = Float(sumTextField.text!)!
        CoreDataManager.shared.saveContext()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueOrderToService {
            guard let servicesVC = segue.destination as? ServicesTableViewController else { return }
            servicesVC.onDidSelect = { [unowned self] (service) in
                self.rowOfOrder?.service = service
                self.serviceTextField.text = self.rowOfOrder?.service?.name
            }
        }
    }

}
