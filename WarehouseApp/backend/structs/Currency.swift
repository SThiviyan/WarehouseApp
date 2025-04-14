//
//  currencies.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//




struct Currency: Codable
{
    let id: Int
    let name: String
    let symbol: String
    
    init(id: Int, name: String, symbol: String) {
        self.id = id
        self.name = name
        self.symbol = symbol
    }
}



