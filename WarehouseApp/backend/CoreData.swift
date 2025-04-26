//
//  CoreData.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 24.04.25.
//


import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    
    lazy var persistenceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AppData")
        
        container.loadPersistentStores{ _, error in
            
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        
        
        return container
        
    }()
    
    private init() {}

    
    func saveAppData()
    {
    }
    
    
    func saveAppData(data: AppData)
    {
        
    }
    
    func saveProduct(item: Product) -> Bool
    {
        let context = persistenceContainer.viewContext
        
        let product = CoreProduct(context: context)
        
        product.id = item.deviceid
        product.serverId = Int64(item.serverId ?? 0)
        product.name = item.productname
        product.barcode = item.barcode
        product.producer = item.producer
        product.productdescription = item.description
        product.price = item.price ?? 0
        product.size = item.size ?? 0
        
        let fetchRequest: NSFetchRequest<CoreCategory> = CoreCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", item.category ?? "" as CVarArg)
        
        
        if let existingCategory = try? context.fetch(fetchRequest).first {
            product.category = existingCategory
        }
        else{
            return false
        }
        
        let unitRequest: NSFetchRequest<CoreUnit> = CoreUnit.fetchRequest()
        unitRequest.predicate = NSPredicate(format: "name == %@", item.unit ?? "" as CVarArg)
        
        
        if let existingUnit = try? context.fetch(unitRequest).first {
            product.unit = existingUnit
        }
        else{
            return false
        }
    
        
        let currencyRequest: NSFetchRequest<CoreCurrency> = CoreCurrency.fetchRequest()
        currencyRequest.predicate = NSPredicate(format: "name == %@", item.currency ?? "" as CVarArg)
    
        if let existingCurrency = try? context.fetch(currencyRequest).first {
            product.currency = existingCurrency
        }
        else{
            return false
        }
       
        
        do {
           try context.save()
        }
        catch {
            return false
        }
        
        return true
    }
    
    
    func delete(item: Product)
    {
        
    }
    
}
