//
//  productImage.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 13.04.25.
//



struct productImage: Codable{
    var DeviceFilePath: String
    
    var ServerFilePath: String?
    var ServerThumbnailFilePath: String?
    
    var uploadedToServer: Bool
    
    mutating func setUploadedToServer(_ value: Bool) {
        self.uploadedToServer = value
    }
}
