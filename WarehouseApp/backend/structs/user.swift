//
//  user.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct User: Codable
{
    var id: Int?
    var email: String
    var password: String
    var login_method: String
    var is_active: Bool
    var created_at: String?
    var currency: String
    var metric: Bool
    var lastJWT: String?
    
    init(id: Int,email: String, password: String, lastJWT: String? = nil, login_method: String, is_active: Bool, currency: String, metric: Bool) {
        self.id = id
        self.email = email
        self.password = password
        self.lastJWT = lastJWT
        self.login_method = login_method
        self.is_active = is_active
        self.currency = currency
        self.metric = metric
    }
    
    mutating func setJWT(jwt: String) {
        lastJWT = jwt
    }
    
}
