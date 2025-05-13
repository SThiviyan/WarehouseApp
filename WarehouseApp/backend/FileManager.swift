//
//  FileManager.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 09.04.25.
//

import Foundation
import CoreData
import SwiftUI


//COREDATA

class StorageManager {
    
    
    let coreDataStack = CoreDataStack.shared
    init(){}
    
    func DataOnFileSystem() -> Bool {
        return coreDataStack.hasAppData() 
    }
    
    
    func getAppData() -> AppData?
    {
        let appData = coreDataStack.getAppData()
        return appData
    }
    
    
    func saveAppData(appData: AppData) -> Bool
    {
        return coreDataStack.saveAppData(data: appData)
    }
    
    
    //SaveProduct method obsolete
    func saveProduct(product: Product) -> Bool
    {
        //return coreDataStack.saveProduct(item: product)
        return false
    }
    
    func removeAppData() -> Bool
    {
        //DELETE ALL IMAGES
        let images: [productImage] = coreDataStack.getAllImageNames()
        
        images.forEach({ value in
            if(value.DeviceFilePath != "")
            {
                //MARK: Think about if a failed image deletion should fail the method? 
                deleteImage(name: value.DeviceFilePath)
            }
        })
        
        
        //DELETE ALL CORE DATA OBJECTS
        coreDataStack.deleteAllCoreDataObjects()
        return true
    }
    
    
    
    
    
    // Images
    func saveImage(image: UIImage, name: String) -> Bool
    {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        let fileURL = documentsDir.appendingPathComponent(name)
                                .appendingPathExtension("jpeg")

        
        guard let data = image.jpegData(compressionQuality: 0.4) else {
            print("failed conversion")
            return false
        }
        
        
        
        //Check if file exists
        if(FileManager.default.fileExists(atPath: fileURL.path))
        {
            //If delete image fails, the method fails
            if(!deleteImage(name: name))
            {
                print("failed")
                return false
            }
        }
       
        
        do{
            try data.write(to: fileURL)
        }
        catch let error {
            print ("error saving file: \(error)")
            return false
        }
        
        return true //TODO
    }
    
    
    func deleteImage(name: String) -> Bool
    {
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        let fileURL = documentsDir.appendingPathComponent(name)
                                .appendingPathExtension("jpeg")

        
        //if file exists, remove file
        if(FileManager.default.fileExists(atPath: fileURL.path))
        {
            do
            {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch
            {
                print("error removing file at path: \(fileURL.path)")
                return false
            }
        }
        return true //TODO
    }
    
    
    func getImage(name: String) -> UIImage? {
        guard !name.isEmpty,
              let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileURL = documentsDir.appendingPathComponent(name)
                                .appendingPathExtension("jpeg")

        
        return UIImage(contentsOfFile: fileURL.path)
    }
    
}
