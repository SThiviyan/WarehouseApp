//
//  Database.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//

import Foundation



class DatabaseConnector {
    //BASEURL
    let baseURL = "https://localhost:3000/api"
    

    
    //
    // LOGIN AND SIGNUP
    //
    
    func signup(email: String, password: String) async -> LoginRequest? {
        let url = baseURL + "/signup"
        let payload: [String: String] = [
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
    
    
    
    //Password change only allowed when connection is possible
    func changePassword(oldPassword: String, newPassword: String, jwt: String) async -> Bool  {
        let url = baseURL + "/changepassword"
        let payload: [String: String] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        let decoder = JSONDecoder()
        
        do{
            let changePasswordRequest = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: payload) ?? Data())
            
            if(changePasswordRequest == "success")
            {
                return true
            }
            else
            {
                return false
            }
        }
        catch{
            print("Password change failed")
            return false
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
    
    func getCategories(_ jwt: String) async -> [Category] {
        if(jwt.isEmpty){return []}
    
        let url = baseURL + "/categories"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let category = try await decoder.decode([Category].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            return category
        }
        catch{
            print("Error: \(error)")
            return []
        }
    }
    
    
    
    
    //
    //  UNITS & CURRENCIES
    //
    
    func getUnits(_ jwt: String) async -> [Unit]{
        if(jwt.isEmpty){return []}
    
        let url = baseURL + "/units"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let units = try await decoder.decode([Unit].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            return units
        }
        catch{
            print("Error: \(error)")
            return []
        }
     }
    
    func getCurrencies(_ jwt: String) async -> [Currency]{
         if(jwt.isEmpty){return []}
     
         let url = baseURL + "/currencies"
         let jwt = jwt
         let decoder = JSONDecoder()
     
         do{
             let currencies = try await decoder.decode([Currency].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
             return currencies
         }
         catch{
             print("Error: \(error)")
             return []
         }
    }
    
    
    
    
    //
    //  PRODUCTS
    //
        
    func getProducts(jwt: String) async -> [Product]
    {
        if(jwt.isEmpty){return []}
    
        let url = baseURL + "/products"
        let jwt = jwt
        let decoder = JSONDecoder()
    
        do{
            let products = try await decoder.decode([Product].self, from: ServerRequest(url, "GET", jwt, payload: nil) ?? Data())
            return products
        }
        catch{
            print("Error: \(error)")
            return []
        }
    }
    //MARK: "Streaming" all Products (decides if all products should be downloaded, or some should be downloaded)
    func streamProducts() -> [Product] {
        
        //guard let url = URL(string: "https://localhost:3000/api/products")
        
        return []
    }
    
    
    
    
    
    
    //TODO: UPLOAD METHODS
    
    
    //UPLOADS IN CASE PRODUCT (OBSOLETE)
    func doDelayedUpload(data: AppData, jwt: String) async -> Bool
    {
        
        if(data.lateRequests.isEmpty)
        {
            //nothing to upload, complete immediately
            return true
        }
        
        
        let jwt = jwt
        
        if jwt == "" && data.UserData != nil {
            let newjwt = data.UserData?.lastJWT
            
            if newjwt == nil {
                //LOGIN HERE TO GET JWT
                return false
            }
        }
        else if data.UserData == nil {
           return false
        }
        
        
        //NEEDS TO BE INDEPENDENT (I.E CATEGORY CAN UPLOAD STILL EVEN IF PRODUCTS FAIL)
        //USE TIME STAMPS TO MAKE SURE, SYNCING IS ALWAYS UP TO DATE
        
        //OPTIMIZATION REQUIRED, IF ONE POST AND ONE DELETE ARE DONE, THEN DELETE IMMEDIATELY
        
        
        
        return true
    }
    
   
    
    //THESE ARE IMMEDIATELY CALLED WHEN USER DELETES / SAVES SOMETHING
    // IF UPLOAD IS NOT POSSIBLE -> A LIST OF REQUESTS WILL SAVE WHAT PRODUCTS NEED TO BE DELETED / SAVED
    // GOES FOR PRODUCTS AND CATEGORIES ? ALSO FOR USERDATA
    
    //UPLOADPRODUCT RETURNS IT'S ServerID
    func uploadProduct(_ product: Product, jwt: String?) async -> Int? {
        let url = baseURL + "/api/product"
        let jwt = jwt
        
        //POST REQ

        let decoder = JSONDecoder()
        
        do{
            let decodedDictionary = try await decoder.decode([String: Int].self, from: ServerRequest(url, "POST", jwt, payload: product) ?? Data())
            
            if let productID = decodedDictionary["productID"]
            {
                print("product uploaded with id: \(productID)")
                return productID
            }
            else
            {
                print("product upload failed")
                return nil
            }
        }
        catch{
            print("product upload failed")
            return nil
        }
        
    }
    
    
    
    func deleteProduct(serverID: Int, jwt: String) async -> Bool {
        let url = baseURL + "/api/product"
        let jwt = jwt
        
        //DELETE REQ
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "DELETE", jwt, payload: serverID) ?? Data())
            
            if(success == "success")
            {
                print("product with \(serverID) deleted")
                return true
            }
            else
            {
                print("product deletion failed")
                return false
            }
        }
        catch{
            print("product deletion failed")
            return false
        }
    }
    
    
    func uploadCategory(_ category: Category, jwt: String) async -> Bool {
        let url = baseURL + "/api/category"
        let jwt = jwt
        
        //POST REQ
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: ["categoryname": category.name]) ?? Data())
            
            if(success == "success")
            {
                print("category uploaded")
                return true
            }
            else
            {
                print("category upload failed")
                return false
            }
        }
        catch{
            print("category upload failed")
            return false
        }
    }
    
    
    func renameCategory(_ oldCategory: Category, _ newCategory: Category, jwt: String) async -> Bool {
        let url = baseURL + "/api/category/rename"
        let jwt = jwt
        
        
        let decoder = JSONDecoder()
        
        do{
            
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: ["oldcategory": oldCategory.name, "newcategory": newCategory.name]) ?? Data())
            
            if(success == "success")
            {
                print("category renamed")
                return true
            }
            else
            {
                print("category rename failed")
                return false
            }
            
        }
        catch
        {
            print("category rename failed")
            return false
        }
    }
    
    
    func deleteCategory(_ category: Category, jwt: String) async -> Bool {
        let url = baseURL + "/api/category"
        let jwt = jwt

        //DELETE REQ
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "DELETE", jwt, payload: ["categoryname": category.name]) ?? Data())
            
            if(success == "success")
            {
                print("category deleted")
                return true
            }
            else
            {
                print("category deletion failed")
                return false
            }
        }
        catch{
            return false
        }

    }
    
    
    func uploadUser(User: User, jwt: String) async -> Bool {
        let url = baseURL + "/api/user"
        let jwt = jwt

        //DELETE REQ
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: User) ?? Data())
            
            if(success == "success")
            {
                return true
            }
            else
            {
                return false
            }
        }
        catch{
            return false
        }
    }
    
    
    
    func deleteImage(serverPath: String, jwt: String) async -> Bool {
        let url = baseURL + "/api/image"
        let jwt = jwt
        
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: serverPath) ?? Data())
            
            if(success == "success")
            {
                return true
            }
            else
            {
                return false
            }
        }
        catch{
            return false
        }
    }
    
    func uploadImage(imageData: Data, jwt: String) async -> String? {
        let url = baseURL + "/api/image"
        let jwt = jwt
        
        
        let decoder = JSONDecoder()
        
        do{
            let success = try await decoder.decode(String.self, from: ServerRequest(url, "POST", jwt, payload: imageData) ?? Data())
            return success
        }
        catch
        {
            return nil
        }
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
    
    
    func ServerRequest(_ urlString: String, _ method: String, _ jwt: String?, payload: Encodable?) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if(jwt != nil)
        {
            request.setValue("Bearer \(jwt ?? "")", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
     
        if let payload = payload
        {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            do
            {
                request.httpBody = try encoder.encode(payload)
            }
            catch
            {
                print("Encoding payload failed: \(error)")
                return nil
            }
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
