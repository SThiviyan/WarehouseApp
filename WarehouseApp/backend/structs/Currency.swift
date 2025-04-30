//
//  currencies.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//




struct Currency: Codable
{
    let name: String
    let symbol: String
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
}



