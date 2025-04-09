//
//  App .swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 28.03.25.
//


class App
{
    var user: user

    
    var userunits: [unit] = []
    var userCurrencies: [currencies] = []
    var usercategories: [categories] = []
    
    var userproducts: [Product] = []
    
    
    var JSONWebToken: String? = ""
    
    init(units: [unit], user: user) {
        
        
        self.userunits = units
        self.user = user
    }
    
    
   static func saveLoginData(email: String, password: String, token: String?){
        
    }
    
    
    
    func refreshUserData()
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





