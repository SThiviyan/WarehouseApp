//
//  categories.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//

struct Categories: Codable
{
    let id: Int
    let user_id: Int
    let name: String
    
    init(id: Int, user_id: Int, name: String) {
        self.id = id
        self.user_id = user_id
        self.name = name
    }
}
