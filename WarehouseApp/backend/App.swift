//
//  App .swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 28.03.25.
//


import Foundation
import UIKit
import SwiftUI




//VIEWMODEL

final class App: ObservableObject
{
    
    static let shared = App()
    
    let Database: DatabaseConnector!
    let Storage: FileManager!
    
    @Published var Data: AppData
    
    
    //variables that are useful
    @Published var lastscannedBarcode: String? = ""
    
    init() {
        self.Database = DatabaseConnector()
        self.Storage = FileManager()
        Data = Storage.getAppData() ?? AppData()
    }
}




//
//  LOGIN METHODS
//
extension App {
    
    func login(email: String, password: String, syncWithServer: Bool) async -> Bool {
        if let loginRequest = await Database.login(email: email, password: password){
            
            await MainActor.run{
                App.shared.Data.UserData = loginRequest.user
                App.shared.Data.UserData?.lastJWT = loginRequest.token
            }
            
            if(syncWithServer)
            {
                if let setupData = await performInitialSetup(){
                    await MainActor.run(body: {
                        Data = setupData
                        print(setupData)
                        //Data.products = getDummyProducts()
                    })
                }
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "LoggedIn")
            
            return true
        }
        
        
        return true
    }
    
    func signup(email: String, password: String) async -> Bool{
        if let signUpRequest = await Database.signup(email: email, password: password){
            App.shared.Data.UserData = signUpRequest.user
            App.shared.Data.UserData?.lastJWT = signUpRequest.token
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "LoggedIn")
            
            return true
        }
        
        //MARK: ON PURPOSE FOR DEVICE TESTING
        return false
    }
    
    
    func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        
        var jwt = App.shared.Data.UserData?.lastJWT ?? ""
        
        if(jwt == "")
        {
            if await !login(email: Data.UserData?.email ?? "", password: Data.UserData?.password ?? "", syncWithServer: false)
            {
                return false
            }
            
            jwt = (App.shared.Data.UserData?.lastJWT)!
        }
        
        if await Database.changePassword(oldPassword: oldPassword, newPassword: newPassword, jwt: jwt){
            return true
        }
        
        
        return false
    }
    
    
    func logout()
    {
        //Logout methods, that deletes all data on file (syncs with server first)
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "LoggedIn")
        
        //Storage.removeFilesFromDevice()
    }
}





//
// DATABASE METHODS FOR FILESYSTEM
//

extension App {
    
    func syncDataWithServer() async -> Bool
    {
        return true
    }
    
    func uploadAllData() async -> Bool
    {
        return true
    }
    
    func saveDataToFile()
    {
        //Saves AppData to a Database or storage
    }

    func downloadAllProducts()
    {
        
    }
}


//
//  USER METHODS (USER; CATEGORIES)
//

extension App {
    
    
    func setUser(_ user: User)
    {
        Data.UserData = user
    }
    
    func getUser() -> User?
    {
        return Data.UserData
    }
    
    
    
    
    func addCategory(name: String) -> Bool
    {
        
        
       Data.categories.append(Category(id: 7, user_id: 1, name: name))

        return true
    }
    
    func setCategories(_ categories: [Category])
    {
        
    }
    
    func removeCategory(_ category: Category)
    {
        
        
    }
    
    
    
    
    func addProduct(_ product: Product) -> Bool
    {
        if(product.barcode == "1")
        {
            return false
        }
        Data.products.append(product)
        //saveAppData to file
        
        return true
    }
    
    func removeProduct(_ product: Product)
    {
        for i in 0..<Data.products.count
        {
            if(Data.products[i].deviceid == product.deviceid)
            {
                Data.products.remove(at: i)
            }
        }
        
    }
    
    func setProduct(newproduct: Product, oldproduct: Product) -> Bool
    {
        for i in 0..<Data.products.count
        {
            if(Data.products[i].deviceid == oldproduct.deviceid)
            {
                Data.products[i] = newproduct
            }
        }
        
        return true
    }
    
    func getProduct(_ barcode: String) -> Product?
    {
        for i in 0..<Data.products.count
        {
            if (Data.products[i].barcode == barcode)
            {
                return Data.products[i]
            }
        }
        
        return nil
    }
    
    
    
}



//
// INITIAL SETUP METHODS
//

extension App {
    
    @MainActor
    func performInitialSetup() async -> AppData?
    {
        if let userdata = Storage.getAppData() {
            return userdata
        }
        else{
            
            let data = AppData()
            
            
            await setUser()
            await setCategories()
            await setUnits()
            await setCurrencies()
            
        }
        return nil
    }
    
    
    func updateAppData(onlyProducts: Bool) -> Bool
    {
        return true
    }
        
    
    //resetting JWT
    @MainActor
    func setUser() async
    {
        let jwt = Data.UserData?.lastJWT ?? ""
        let user = await Database.getUser(jwt)
        Data.UserData = user
    }
    
    @MainActor
    func setCategories() async
    {
        
    }
    
    
    @MainActor
    func setCurrencies() async
    {
        
    }
    
    @MainActor
    func setUnits() async
    {
        
    }
    
}
