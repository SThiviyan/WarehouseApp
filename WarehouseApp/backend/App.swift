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
    }
    
    
   
    
    func getUser() async -> User?
    {
        let jwt = Data.UserData?.lastJWT ?? ""
        let user = await Database.getUser(jwt)
        return Data.UserData
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
    
    func logout()
    {
        //Logout methods, that deletes all data on file (syncs with server first)
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
}





//
// FILESYSTEM METHODS
//

extension App {
    func syncDataWithServer() async -> Bool
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
