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
        
        Data = AppData()


        // LOADS DATA FROM FILE SYSTEM
        Data.products = getDummyProducts()
        let _appdata = self.Storage.getAppData()
            
        if(_appdata == nil)
        {
            Task
            {
                //DOES INTIIALSETUP BY LOADING FILES FROM SERVER
                Data = await performInitialSetup()!
            }
        }
        else
        {
            if(Data.UserData != nil)
            {
                Data = _appdata!
            }
            else
            {
                
            }
        }
            
    }
       
    
    
}




//
//  LOGIN METHODS
//
extension App {
    
    func login(email: String, password: String, syncWithServer: Bool) async -> Bool {
        if let loginRequest = await Database.login(email: email, password: password){
            App.shared.Data.UserData = loginRequest.user
            App.shared.Data.UserData?.lastJWT = loginRequest.token
            
            if(syncWithServer)
            {
                Data = await performInitialSetup()!
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "LoggedIn")
            defaults.set(false, forKey: "FirstLaunch")
            
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
            defaults.set(false, forKey: "FirstLaunch")
            
            return true
        }
        
        return false
    }
    
    
    func changePassword(oldPassword: String, newPassword: String) -> Bool {
        return false
    }
    
    
    func logout()
    {
        //Logout methods, that deletes all data on file (syncs with server first)
        
        let defaults = UserDefaults.standard
        
        defaults.set(false, forKey: "LoggedIn")
        defaults.set(true, forKey: "FirstLaunch")
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
        
        return false
    }
    
    func setCategories(_ categories: [Category])
    {
        
    }
    
    func removeCategory(_ category: Category)
    {
        
        
    }
    
    
    
    
    func addProduct(_ product: Product)
    {
        print("add Product")
        //if barcode == 1, error from addview or lookupview.
        if(product.barcode != "1")
        {
            
        }
    }
    
    func removeProduct(_ product: Product)
    {
        print("remove Product")
    }
    
    func setProduct(_ product: Product)
    {
        print("Setting product with name: \(product.productname)")
        
    }
    
    func getProduct(_ barcode: String) -> Product?
    {
        return nil
    }
    
    
    
}



//
// INITIAL SETUP METHODS
//

extension App {
    
    func performInitialSetup() async -> AppData?
    {
        await setUser()
        await setCategories()
        await setUnits()
        await setCurrencies()
        
        return nil
    }
    
    
    func updateAppData(onlyProducts: Bool) -> Bool
    {
        return true
    }
        
    
    //resetting JWT
    func setUser() async
    {
        let jwt = Data.UserData?.lastJWT ?? ""
        let user = await Database.getUser(jwt)
        Data.UserData = user
    }
    
    func setCategories() async
    {
        
    }
    
    
    func setCurrencies() async
    {
        
    }
    
    
    func setUnits() async
    {
        
    }
    
}
