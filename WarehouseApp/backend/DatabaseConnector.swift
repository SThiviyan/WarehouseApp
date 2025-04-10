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

struct DatabaseConncetor {


    let userInfoUrl: URL = URL(string: "http://localhost:3000/api/userinfo")!
    let unitsUrl: URL = URL(string: "http://localhost:3000/api/units")!
    let categoriesUrl: URL = URL(string: "http://localhost:3000/api/categories")!
    let productsUrl: URL = URL(string: "http://localhost:3000/api/products")!

    
    
    let baseURL = "https:localhost:3000"
    
    
    func signup(email: String, password: String) async -> String? {
        
        guard let url = URL(string: baseURL + "/signup") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "username": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: UnsafeSessionDelegate(), delegateQueue: nil)
        
        do{
            let (data, _) = try await session.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let token = json?["token"] as? String
            return token ?? nil
        }
        catch{
            print("Login failed with error: \(error.localizedDescription)")
            return nil
        }
}
    
    
    func login(email: String, password: String) async -> String? {
        
        guard let url = URL(string: baseURL + "/login") else { return nil }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           let payload = ["username": email, "password": password]
           request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

           let config = URLSessionConfiguration.default
           let session = URLSession(configuration: config, delegate: UnsafeSessionDelegate(), delegateQueue: nil)

           do {
               let (data, _) = try await session.data(for: request)
               let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
               let token = json!["token"] as? String
               return token ?? nil
           } catch {
               print("Login failed with error: \(error.localizedDescription)")
               return nil
           }
    }
    
    //Generally shouldn't be used, Only for TableView, but load lazy
    static func getAllProducts() -> [Product] {
        
        //guard let url = URL(string: "https://localhost:3000/api/products")
        
        return []
    }
    
    func getAllCategories() -> [Category]? {
        
        guard let url = URL(string: baseURL + "/api/categories") else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Bearer \(App.JSo)", forHTTPHeaderField: "Authorization")
        
        
        
        return []
    }
    
    static func getAllUnits() -> [unit] {
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
    
    
    
    

    
    
    
    static func fetchCategories() async {
       
    }
    
    
   static func fetchUserInfo() async {
        
   }
    
   static func fetchUnits() async -> [unit]{
        
        if let url = URL(string: "http://localhost:8080/api/units") {
            do{
                let(data, _) = try await URLSession.shared.data(from: url)
                
                let decoder = JSONDecoder()
                let units = try decoder.decode([unit].self, from: data)
                
                print("Units data: \(units)")
                
                return units
            }
            
            catch
            {
                print("GET UNITS ERROR", error)
            }
        }
       
       return []
    }
    
}



//MARK: ONLY FOR DEVELOPMENT
class UnsafeSessionDelegate: NSObject, URLSessionDelegate {
    // This allows self-signed certs by ignoring SSL errors
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        completionHandler(.useCredential, credential)
    }
}
