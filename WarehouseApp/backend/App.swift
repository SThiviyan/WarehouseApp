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
    let Storage: StorageManager!
    
    @Published var Data: AppData
    
    
    
    //variables that are useful
    @Published var selectedProduct: Product?
    
    init() {
        self.Database = DatabaseConnector()
        self.Storage = StorageManager()
        Data = Storage.getAppData() ?? AppData()
        print(Storage.getAppData())
    }
}




//
//  LOGIN METHODS
//
extension App {
    
    func login(email: String, password: String, syncWithServer: Bool) async -> Bool {
        if let loginRequest = await Database.login(email: email, password: password){
            
            var user = loginRequest.user
            user.lastJWT = loginRequest.token
            
            
            if(syncWithServer)
            {
                if let setupData = await performInitialSetup(user: user){
                    
                    print("==================================")
                    print (setupData)
                    print("==================================")

                    let saveSucceeded = await MainActor.run { () -> Bool in
                        Data = setupData
                        return Storage.saveAppData(appData: Data)
                    }
                    
                    guard saveSucceeded else {return false}
                    
                }
            }
            
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "LoggedIn")
            
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
        
        Storage.removeAppData()
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
    
    func saveDataToFile() async -> Bool
    {
        //Saves AppData to a Database or storage
        if(!Storage.coreDataStack.saveAppData(data: Data))
        { return false }
        
        if (await !Database.uploadAppData(data: Data, jwt: Data.UserData?.lastJWT))
        { return false }
            
        return true
    }
    
    
    func fetchAllProducts(jwt: String) async -> [Product]
    {
        return await Database.getProducts(jwt: jwt)
    }
    
    func fetchUserData(jwt: String) async -> User?
    {
        let user = await Database.getUser(jwt)
        
        return user
    }
    
    func fetchCategories(jwt: String) async -> [Category]
    {
        return await Database.getCategories(jwt)
    }
    
    func fetchUnits(jwt: String) async -> [Unit]
    {
        let units = await Database.getUnits(jwt)
        
        return units
    }
    
    func fetchCurrencies(jwt: String) async -> [Currency]
    {
        let currencies = await Database.getCurrencies(jwt)
        
        return currencies
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
    
    
    func addCategory(category: Category) -> Bool
    {
        
        if(Data.categories.contains(where: { $0.name.lowercased() == category.name.lowercased() } ))
        {
            return false
        }
        Data.categories.append(category)
        return true
    }
    
    func setCategories(_ categories: [Category])
    {
        Data.categories = categories
    }
    
    func renameCategory(oldCategory: Category, newName: String)
    {
        let oldCategoryName = oldCategory.name.lowercased()
        let index = Data.categories.firstIndex(where: {$0.name.lowercased() == oldCategoryName})
        
        Data.categories.replaceSubrange(index!..<index!, with: [Category(name: newName)])
    }
    
    func removeCategory(_ category: Category)
    {
        Data.categories.removeAll(where: { $0.name.lowercased() == category.name.lowercased()})
    }
    
    
    
    
    func addProduct(_ product: Product) -> Bool
    {
        if(product.barcode == "1")
        {
            return false
        }
        Data.products.append(product)
        
        
        
        return true
    }
    
    func removeProduct(_ product: Product)
    {
        if let index = Data.products.firstIndex(where: {$0.deviceid == product.deviceid})
        {
            Data.products.remove(at: index) 
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
    func performInitialSetup(user: User) async -> AppData?
    {
        if var userdata = Storage.getAppData() {
            userdata.UserData = user
            return userdata
        }
        else{
            
            var data = AppData()
            
            if(user.lastJWT == nil || user.lastJWT == "")
            {
                return nil
            }
            
            
            data.UserData = user
            data.units = await fetchUnits(jwt: user.lastJWT!)
            data.products = await fetchAllProducts(jwt: user.lastJWT!)
            data.currencies = await fetchCurrencies(jwt: user.lastJWT!)
            
            /*
            print("USERDATA::::::::::::::::::::::::::::::::::::::::::::::::::")
            print(data)
            print("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
             */
            
            return data
        }
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
