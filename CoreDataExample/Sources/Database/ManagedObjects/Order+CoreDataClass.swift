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
}
