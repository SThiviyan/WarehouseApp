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
}


extension CoreDataStack {
    
    func saveAppData()
    {
    }
    
    
    func saveProduct()
    {
        
    }
    
    
    func delete(item: Product)
    {
        
    }
    
}
