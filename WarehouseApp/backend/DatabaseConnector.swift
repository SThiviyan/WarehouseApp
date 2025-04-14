//
//  Database.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//

import Foundation


class DatabaseConnector {
    
    
    
    //BASEURL
    let baseURL = "https:localhost:3000/api"
    
    
    
    //
    // LOGIN AND SIGNUP
    //
    
    func signup(email: String, password: String) async -> LoginRequest? {
        let url = baseURL + "/signup"
        let payload: [String: Any] = [
            "username": email,
            "password": password
        ]
        let decoder = JSONDecoder()
       
        do{
            let loginreq =  try await decoder.decode(LoginRequest.self, from: ServerRequest(url, "POST", nil, payload: payload) ?? Data())
            return loginreq
        }
        catch{
            print("Login failed with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func login(email: String, password: String) async -> LoginRequest?
    {
        let url = baseURL + "/login"
        let payload = ["username": email, "password": password]
        let decoder = JSONDecoder()
        
        do{
            //MARK: Look into this is the default value Data() appropriate
            let loginreq =  try await decoder.decode(LoginRequest.self, from: ServerRequest(url, "POST", nil, payload: payload) ?? Data())
            return loginreq
        }
        catch{
            print("Login failed with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    
    
    //
    // USER
    //
    
    func getUser(_ jwt: String) async -> User? {
        if(jwt.isEmpty){return nil}
    
        let url = baseURL + "/userdata"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let user = try await decoder.decode([User].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            if(user.isEmpty){
                return nil
            }
            return user[0]
        }
        catch{
            print("Error: \(error)")
            return nil
        }
    }
    
    
    func setUser(_ user: User, _ jwt: String) async -> Bool {
        if(jwt.isEmpty){return false}
        
        let url = baseURL + "/userdata"
        let jwt = jwt
        let payload = user
        
        guard (await ServerRequest(url, "POST", jwt, payload: payload)) != nil else {return false}
        return true
    }
  
        
    
    
    
    
    //
    // CATEGORIES
    //
    
    func getCategories(_ jwt: String) async -> [Category]? {
        if(jwt.isEmpty){return nil}
    
        let url = baseURL + "/categories"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let category = try await decoder.decode([Category].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            return category
        }
        catch{
            print("Error: \(error)")
            return nil
        }
    }
    
    func AddCategories(_ jwt: String) async -> Bool{
        return false
    }
    
    
    
    //
    //  UNITS
    //
    
    func getUnits(_ jwt: String) async -> [Unit]?{
        if(jwt.isEmpty){return nil}
    
        let url = baseURL + "/units"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let units = try await decoder.decode([Unit].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            return units
        }
        catch{
            print("Error: \(error)")
            return nil
        }
     }
    
    func getCurrencies(_ jwt: String) async -> [Currency]?{
         if(jwt.isEmpty){return nil}
     
         let url = baseURL + "/currencies"
         let jwt = jwt
         let decoder = JSONDecoder()
     
         do{
             let currencies = try await decoder.decode([Currency].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
             return currencies
         }
         catch{
             print("Error: \(error)")
             return nil
         }
    }
    
    
    
    
    //
    //  PRODUCTS
    //
    
    func setProduct(_ product: Product, _ jwt: String) async -> Bool {
        return false
    }
    
    func getProduct()
    {
        
    }
    
    func addProduct(_ product: Product, _ imageData: Data, _ jwt: String) async -> Bool {
        return false
    }
    
    
    func deleteProduct(_ productId: Int, _ jwt: String) async -> Bool {
        return false
    }
    
    
    //MARK: "Streaming" all Products (decides if all products should be downloaded, or some should be downloaded)
    func streamProducts() -> [Product] {
        
        //guard let url = URL(string: "https://localhost:3000/api/products")
        
        return []
    }
    
    
    
    
    
    //
    //
    //  REQUESTS
    //
    //
    
    func requestImage(_ urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("Error downloading image: \(error)")
            return nil
        }
    }
    
    
    func ServerRequest(_ urlString: String, _ method: String, _ jwt: String?, payload: Any?) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if(jwt != nil)
        {
            request.setValue("Bearer \(jwt ?? "")", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
     
        if(payload != nil)
        {
            request.httpBody = try? JSONSerialization.data(withJSONObject: payload ?? [:])
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: UnsafeSessionDelegate(), delegateQueue: nil)
        
        do {
            let (data, _) = try await session.data(for: request)
            return data
        } catch {
            print("Error getting Data: \(error)")
            return nil
        }
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
