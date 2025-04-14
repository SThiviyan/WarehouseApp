//
//  user.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct User: Codable
{
    let id: Int?
    let email: String?
    let password: String?
    let login_method: String?
    let is_active: Bool?
    let created_at: String?
    let currency: String?
    let metric: Bool?
    var lastJWT: String?
    
  
    
    mutating func setJWT(jwt: String) {
        lastJWT = jwt
    }
    
}
