//
//  unit.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct Unit: Codable
{
    let id: Int
    let name: String
    let shortname: String
    
    init(id: Int, name: String, shortname: String) {
        self.id = id
        self.name = name
        self.shortname = shortname
    }
}


