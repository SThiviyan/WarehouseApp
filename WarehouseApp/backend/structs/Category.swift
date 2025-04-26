//
//  categories.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//

import Foundation

struct Category: Codable
{
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
