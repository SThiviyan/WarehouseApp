//
//  productImage.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 13.04.25.
//



struct productImage: Codable{
    let DeviceFilePath: String
    
    let ServerFilePath: String?
    let ServerThumbnailFilePath: String?
    
    var uploadedToServer: Bool
    
    mutating func setUploadedToServer(_ value: Bool) {
        self.uploadedToServer = value
    }
}
