//
//  Database.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//

import Foundation


//save, delete, getall, withUUIDgetOne, withBarcodegetOne,
//MARK: THIS DEFINITELY NEEDS TO BE DONE
//either coredata (not crossplatform) or sqlite or firebase

struct Database{
    
    func authenticate() -> Bool {
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/api")!)
        request.httpMethod = "GET"
        
        return true
    }
    
    //Generally shouldn't be used, Only for TableView, but load lazy
    static func getAllProducts() -> [Product] {
        return []
    }
    
    static func getAmountOfProducts() -> Int {
        return 0
    }
    
    static func saveProduct(_ product: Product) {
            
    }
    
    static func deleteProduct(withId id: UUID) {
        
    }
    
    static func getProduct(withId id: UUID) -> Product? {
        return nil
    }
    
    static func getProduct(withBarcode barcode: String) -> Product? {
        return nil
    }

    
}
