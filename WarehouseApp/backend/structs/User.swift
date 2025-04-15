//
//  user.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct User: Codable
{
    var id: Int?
    var email: String?
    var password: String?
    var login_method: String?
    var is_active: Bool?
    var created_at: String?
    var currency: String?
    var metric: Bool?
    var lastJWT: String?
    
    var saveDataToDevice: Bool? = true
    
  
    
    mutating func setJWT(jwt: String) {
        lastJWT = jwt
    }
    
}
