//
//  FileManager.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 09.04.25.
//

import Foundation
import CoreData
import SwiftUI


//COREDATA

class FileManager {
    
    
    let coreDataStack = CoreDataStack.shared
    init(){}
    
    func DataOnFileSystem() -> Bool {
        return coreDataStack.hasAppData() 
    }
    
    
    func getAppData() -> AppData?
    {
        let appData = coreDataStack.getAppData()
        return appData
    }
    
    
    func saveAppData(appData: AppData) -> Bool
    {
        print("savedAppData")
        return coreDataStack.saveAppData(data: appData)
    }
    
    func saveProduct(product: Product) -> Bool
    {
        //return coreDataStack.saveProduct(item: product)
        return false
    }
    
   
    
    func removeAppData() -> Bool
    {
        return coreDataStack.deleteAllCoreDataObjects()
    }
    
    
    
    
    
    // Images
    
    func saveImage(image: Data, name: String) -> Bool
    {
        return true //TODO
    }
    
    
    func deleteImage(name: String) -> Bool
    {
        return true //TODO
    }
    
    
}
