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
        
      
        print("======================STORAGE==========================")
        print(Storage.getAppData())
        print("======================STORAGE==========================")

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


// app saves only after closing to coredata but uploads products and categories immediately 

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
        
        
        /*
        if (await !Database.doDelayedUpload(data: Data, jwt: Data.UserData?.lastJWT!))
        { return false }
         */
            
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
    
    
    
    
    func addProduct(_ pr: Product, image: UIImage?) -> Bool
    {
        
        
        var serverID: Int?
        
        //UPLOAD TO SERVER
        Task{
            serverID = await Database.uploadProduct(pr, jwt: Data.UserData?.lastJWT)
            //if no productID is returned by UploadProduct then add to LateRequests
            if(serverID == nil)
            {
                let req = LateUploadRequest(type: uploadtype.POST, object: pr, timeStamp: Date())
                addLateRequest(request: req)
                
                if(image != nil)
                {
                    //Image LateRequest
                    let ImageReq = LateUploadRequest(type: uploadtype.POST, object: image!, timeStamp: Date())
                    addLateRequest(request: ImageReq)
                }
            }
        }
        
        
        //LOCAL CHANGES
        //Local changes are done after uplaod to server, because server can return a serverID for products
        if(pr.barcode == "1")
        {
            return false
        }
        
        
        var product = Product(initialID: pr.deviceid, product: pr)
        product.serverId = serverID
       
        if(image != nil)
        {
            if(Storage.saveImage(image: image!, name: pr.productImage?.DeviceFilePath ?? ""))
            {
                Data.products.append(pr)
                return true
            }
        }
      
        Data.products.append(pr)
        return true
    }
    
    func removeProduct(_ product: Product)
    {
        
     
        
        //LOCAL CHANGES
        if let index = Data.products.firstIndex(where: {$0.deviceid == product.deviceid})
        {
            
           
            
            //SERVER SIDE CHANGES
            
            var serverID = Data.products[index].serverId
            //If no ServerID exists, the product was not uploaded
            if(serverID != nil)
            {
                Task{
                    if(await Database.deleteProduct(serverID: serverID!, jwt: Data.UserData?.lastJWT ?? "") == false){
                        Data.lateRequests.append(LateUploadRequest(type: uploadtype.DELETE, object: product, timeStamp: Date()))
                    }
                    
                    if(Data.products[index].productImage?.DeviceFilePath != "")
                    {
                        if(await Database.deleteImage(serverID: serverID!, jwt: Data.UserData?.lastJWT ?? "") == false)
                        {
                            let productImage = Data.products[index].productImage
                            Data.lateRequests.append(LateUploadRequest(type: uploadtype.DELETE, object: productImage!, timeStamp: Date()))
                        }
                    }
                }
            }
            
            
            
            if(Data.products[index].productImage?.DeviceFilePath != "")
            {
                Storage.deleteImage(name: Data.products[index].productImage?.DeviceFilePath ?? "")
            }
            
            Data.products.remove(at: index)
            
        }
        
        
    }
    
    func setProduct(newproduct: Product, oldproduct: Product, newImage: UIImage?) -> Bool
    {
        
        //LOCAL CHANGES
        for i in 0..<Data.products.count
        {
            if(Data.products[i].deviceid == oldproduct.deviceid)
            {
               
                var serverID: Int?
                //UPLOAD TO SERVER
                Task{
                    //check for ServerID just in Case
                    serverID = await Database.uploadProduct(Data.products[i], jwt: Data.UserData?.lastJWT!)
                    if(serverID == nil)
                    {
                        let req = LateUploadRequest(type: uploadtype.POST, object: Data.products[i], timeStamp: Date())
                        addLateRequest(request: req)
                        
                        //ImageLateRequest needs to be added (delete old image, add new)
                    }
        
                }
                
                
                var toSave = Product(initialID: oldproduct.deviceid, product: newproduct)
                
                //toSave gets a serverID if the product didn't have one, otherwise the server ID won't be overwritten
                // => in case of await Database.uploadProduct fails and returns nil for serverID, even though the serverID is already saved in oldProduct
                if(toSave.serverId == nil)
                {
                    toSave.serverId = serverID
                }
                
                
                if(oldproduct.productImage?.DeviceFilePath != "" && oldproduct.productImage != nil)
                {
                    
                    let filepath = (oldproduct.productImage?.DeviceFilePath)!
                    
                    if(Storage.deleteImage(name: filepath))
                    {
                       print("deleted old Image for new Image / Replace")
                    }
                }
                
                if(newImage != nil)
                {
                    if(Storage.saveImage(image: newImage!, name: newproduct.productImage?.DeviceFilePath ?? ""))
                    {
                        print("ImageSaved")
                    }
                }
                
                Data.products[i] = toSave
                
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
    
    
    func getImage(product: Product) -> UIImage?
    {
        if(product.productImage?.DeviceFilePath != "")
        {
            let filepath = (product.productImage?.DeviceFilePath)!
            return Storage.getImage(name: filepath)
        }
        else
        {
            
            return nil
        }
    }
    
    func getImage(url: String) -> UIImage?
    {
        if(url != "")
        {
            return Storage.getImage(name: url)
        }
        else
        {
            print("Image with name \(url) not found")
            return nil
        }
    }
    
    
    
    func setSaveProductsToDevice(value: Bool)
    {
        if(value)
        {
        }
        else
        {
            
        }
    }
    
    
    
    func addLateRequest(request: LateUploadRequest)
    {
        //Optimierung der LateRequest Queue hier notwendig!
        
        Data.lateRequests.append(request)
    }
    
    func getFirstLateRequests() -> LateUploadRequest?
    {
        return Data.lateRequests.first
    }
    
    
    func removeFirstLateRequest()
    {
        if(!Data.lateRequests.isEmpty)
        {
            Data.lateRequests.removeFirst()
        }
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
