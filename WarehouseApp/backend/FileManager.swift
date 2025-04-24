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
    
    
    @StateObject var coreDataStack = CoreDataStack.shared
    
    
    init() {
        
    }
    
    func DataOnFileSystem() -> Bool {
        return true
    }
    
    
    
    func getAppData() -> AppData?
    {
        var appData = AppData()
        
        //appData.products = getDummyProducts()
        appData.products = []
        appData.categories = getDummyCategories()

    
        return nil
    }
    
    
    func saveAppData(appData: AppData) -> Bool{
        
        
        return true
    }
    
    
    
    func saveJSONtoFile(data: Data, fileName: String) {
        
    }
    
    
    func deleteJSONFile(fileName: String) {
        
    }
    
    
    func readJSONfromFile(fileName: String) -> Data? {
        return nil
    }
    
    func writeJSONtoFile(data: Data, fileName: String) {
        
        
        
    }
    
    
    
    
}
