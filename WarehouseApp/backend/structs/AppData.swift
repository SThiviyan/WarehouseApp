//
//  AppData.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 09.04.25.
//
import Foundation
import SwiftData

struct AppData
{
    var categories: [Category]
    var products: [Product]
    var units: [Unit]
    var UserData: User?
    var currencies: [Currency]? 
    
    
    init(categories: [Category], products: [Product], units: [Unit], UserData: User) {
        self.categories = categories
        self.products = products
        self.units = units
        self.UserData = UserData
    }
    
    init(){
        products = []
        categories = []
        units = []
        UserData = User()
    }
}
