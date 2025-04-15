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
    
    @Published var Data: AppData!
    
    
    init() {
        self.Database = DatabaseConnector()
        self.Storage = FileManager()
        
        Data = AppData()
        //App.shared.Data.products = getDummyProducts()
        if(self.Storage.DataOnFileSystem())
        {
            
        }
        
        Data.products = getDummyProducts()
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
                
            }
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "LoggedIn")
            defaults.set(false, forKey: "FirstLaunch")
            
            return true
        }
        return false
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
// FILESYSTEM METHODS
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
//  SET METHODS
//

extension App {
    
    
    func setUser(_ user: User)
    {
        
        print("Setting usedatar: \(String(describing: user.email))")
        Data.UserData = user
    }
    
    
    
    func addCategory(name: String) -> Bool
    {
        
        return false
    }
    
    func setCategories(_ categories: [Category])
    {
        
    }
    
    
    
    
    
    func addProduct(_ product: Product)
    {
        print("add Product")
    }
    
    func removeProduct(_ product: Product)
    {
        print("remove Product")
    }
    
    func setProduct(_ product: Product)
    {
        print("Setting product with name: \(product.productname)")
        
    }
    
    
}



//
// GET METHODS
//

extension App {
    
    func performInitialSetup() async
    {
        await setUser()
        await setCategories()
        await setUnits()
        await setCurrencies()
    }
    
    
    func updateAppData(onlyProducts: Bool) -> Bool
    {
        return true
    }
    
    
    func setUser() async
    {
        let jwt = Data.UserData?.lastJWT ?? ""
        let user = await Database.getUser(jwt)
        Data.UserData = user
    }
    
    
    func setCategories() async
    {
        
    }
    
    func setProducts() async
    {
        
    }
    
    func setUnits() async
    {
        
    }
    
    func setCurrencies() async
    {
        
        
    }
    
    
}
