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
        print("savedAppData")
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
        
        
        print("SavedURL===========================================")
        print(fileURL)
        print("SavedURL===========================================")

        guard let data = image.pngData() else {
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
            print("DATAWRITE================================>")
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
        
        print("RetrieveURL===========================================")
        print(fileURL)
        print("RetrieveURL===========================================")

        
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
            print("📂 File exists? \(exists)")

        return UIImage(contentsOfFile: fileURL.path)
    }
    
}
