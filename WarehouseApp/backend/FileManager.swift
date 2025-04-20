//
//  FileManager.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 09.04.25.
//

import Foundation



class FileManager {
    
    
    
    init() {
        
    }
    
    func DataOnFileSystem() -> Bool {
        return true
    }
    
    
    
    func getAppData() -> AppData?
    {
        var appData = AppData()
        
        appData.products = getDummyProducts()
        appData.categories = getDummyCategories()

    
        return appData
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
