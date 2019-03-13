//
//  Order+CoreDataClass.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/12/19.
//  Copyright © 2019 vinso. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    convenience init() {
        self.init(context: CoreDataManager.shared.persistentContainer.viewContext)
    }
    
    func getRowsOfOrder(order: Order) -> NSFetchedResultsController<RowOfOrder> {
        let fetchRequest = NSFetchRequest<RowOfOrder>(entityName: RowOfOrder.entity().name!)
        
        let sortDescriptor = NSSortDescriptor(key: "service.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "%K == %@", "order", order)
        fetchRequest.predicate = predicate
        
        let fetchResultController = NSFetchedResultsController<RowOfOrder>(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
