//
//  user.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct user: Codable
{
    var id: Int
    var email: String
    var password: String
    var login_method: String
    var is_active: Bool
    var currency: String
    var metric: Bool
}
