//
//  categories.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 03.04.25.
//

import Foundation

struct Category: Codable
{
    var name: String
    
    init(name: String) {
        self.name = name
    }
}



//for upload, and lateuploadRequests
struct renameCategoryRequest: Codable
{
    var oldName: String
    var newName: String
}
