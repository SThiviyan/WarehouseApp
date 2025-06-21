//
//  ImageUpload.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 21.06.25.
//

import Foundation

struct ImageUpload: Codable
{
    var img: Data
    var name: String
    
    init(img: Data, name: String) {
        self.img = img
        self.name = name
    }
}
