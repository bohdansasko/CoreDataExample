//
//  CoreDataManager.swift
//  CoreDataExample
//
//  Created by Bogdan Sasko on 3/12/19.
//  Copyright © 2019 vinso. All rights reserved.
//

import CoreData

protocol IDatabaseManager {
    func addCustomer(name: String, info: String?)
    func deleteCustomers()
    func showCustomerFromDB()
    func saveContext()
}

class CoreDataManager: IDatabaseManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getFetchedResultsController<T:NSManagedObject>(entityName: String, sortKey: String) -> NSFetchedResultsController<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }
    
    func addCustomer(name: String, info: String?) {
        let customer = Customer(context: persistentContainer.viewContext)
        customer.name = name
        customer.info = info
    }
    
    func deleteCustomers() {
        let request = NSFetchRequest<Customer>(entityName: Customer.entity().name!)
        do {
            let customers = try persistentContainer.viewContext.fetch(request)
            customers.forEach({ customer in
                print("delete customer from db - \(customer.value(forKey: "name") ?? "can't found key")")
                persistentContainer.viewContext.delete(customer)
            })
        } catch (let err) {
            print(err)
        }
    }
    
    func delete<T: NSManagedObject>(managedObj: T) {
        persistentContainer.viewContext.delete(managedObj)
    }
    
    
    
    func showCustomerFromDB() {
        let request = NSFetchRequest<Customer>(entityName: Customer.entity().name!)
        do {
            guard let customer = try persistentContainer.viewContext.fetch(request).first else {
                print("Hasn't records")
                return
            }
            print("customer value from db - \(customer.name!)")
        } catch (let error) {
            print(error)
        }
    }

    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("Save context")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
