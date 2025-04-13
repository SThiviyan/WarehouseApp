//
//  App .swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 28.03.25.
//


import Foundation


final class App: ObservableObject
{
    //var user: user = nil as! user

    
    static let shared = App()
    
    let Database: DatabaseConnector!
    let Storage: FileManager!
    
    var Data: AppData!
        
    
    
    var JSONWebToken: String? = ""
    
    init() {
        
        self.Database = DatabaseConnector()
        self.Storage = FileManager()
        
      
        Data = AppData()
        
        if(self.Storage.DataOnFileSystem())
        {
            
        }
    }
    
    func login(email: String, password: String) async -> Bool {
                
        
        if let loginRequest = await Database.login(email: email, password: password){
            App.shared.Data.UserData = loginRequest.user
            App.shared.Data.UserData?.lastJWT = loginRequest.token
            return true
        }
        else{
            return false
        }
        
    }
    
    func signup(email: String, password: String) async -> Bool{
        if let signUpRequest = await Database.signup(email: email, password: password){
            App.shared.Data.UserData = signUpRequest.user
            App.shared.Data.UserData?.lastJWT = signUpRequest.token
            return true
        }
        else{
            return false
        }
        
    }
    
    func saveUserData(email: String, password: String, login_method: String, currency: String, metric: Bool)
    {
        
    }
    
    
  
    
    static func downloadAllProducts()
    {
        print("downloading All User Products")
    }
    
    
    func getJSONWebToken() -> String?
    {
        return JSONWebToken
    }
    
    
    
}





