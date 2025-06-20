//
//  LateUploadRequest.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 24.05.25.
//


import Foundation



struct LateUploadRequest: Codable
{
    let uploadtype: Int //Type 0 -> POST; Type 1 -> DELETE
    let object: Data
    let objectType: String
    let timeStamp: Date
    
    
    //  Explanation
    //  uploadtype -> 0 = POST; 1 = DELETE;
    //  object: Data -> the Object (Category or Product) without type, due to constraints of CoreData
    //  objectType: either String(describing: category.self v product.self) or "img" 
    //  timestamp from creation
    
    //This is for retrieval from CoreData
    init(uploadtype: Int, object: Data, objectType: String, timeStamp: Date) {
        self.uploadtype = uploadtype
        self.object = object
        self.objectType = objectType
        self.timeStamp = timeStamp
    }
    
    
    //for adding a new lateUploadRequest
    init(uploadtype: Int, object: Any, objectType: String, timeStamp: Date) {
        self.uploadtype = uploadtype
        
        //conversion needs to change
        self.object = object as! Data
        
        self.objectType = objectType
        self.timeStamp = timeStamp
    }
}
