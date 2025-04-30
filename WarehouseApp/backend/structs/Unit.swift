//
//  unit.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//



struct Unit: Codable
{
    let name: String
    let shortname: String
    
    init(name: String, shortname: String) {
        self.name = name
        self.shortname = shortname
    }
}


