//
//  LateUploadRequest.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 24.05.25.
//


import Foundation

enum uploadtype{
    case POST
    case DELETE
}


struct LateUploadRequest
{
    let type: uploadtype
    let object: Any
    let timeStamp: Date
    
    init(type: uploadtype, object: Any, timeStamp: Date, objectType: String?) {
        self.type = type
        self.object = object
        self.timeStamp = timeStamp
    }
}
