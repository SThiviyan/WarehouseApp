//
//  LoginRequest.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 10.04.25.
//


// for JSON parsing from Server

struct LoginRequest: Codable
{
    let token: String
    let user: User
}
