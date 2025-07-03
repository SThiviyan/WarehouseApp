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
    init<T: Codable>(uploadtype: Int, object: T, objectType: String, timeStamp: Date) {
        self.uploadtype = uploadtype
        
        //conversion needs to change
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do{
            self.object = try encoder.encode(object)
        }
        catch
        {
            fatalError("Failed to encode object")
        }
        
        self.objectType = objectType
        self.timeStamp = timeStamp
    }
    
    func getdecodedObject<T: Codable>() -> T?
    {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do{
            return try decoder.decode(T.self, from: object)
        }
        catch
        {
            print("Failed to decode object")
            return nil
        }
    }
}
