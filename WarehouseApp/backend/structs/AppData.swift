//
//  AppData.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 09.04.25.
//


struct AppData
{
    var categories: [Categories]? = nil
    var products: [Product]? = nil
    var units: [Unit]? = nil
    var UserData: User? = nil
    
    
    init(categories: [Categories], products: [Product], units: [Unit], UserData: User) {
        self.categories = categories
        self.products = products
        self.units = units
        self.UserData = UserData
    }
    
    init(){
        
    }
}
