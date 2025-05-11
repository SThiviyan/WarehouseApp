//
//  File.swift
//  WarehouseApp
//
//  Created by Thiviyan Saravanamuthu on 10.05.25.
//

import Foundation
import UIKit

class ImageLoader
{
    @Published var ImageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

    
    init(){
      

    }
}

//A Struct that controlls what images are loaded 
struct AppImage {
    let image: UIImage
    let assignedProduct: UUID
    
    init(image: UIImage, assignedProduct: UUID) {
        self.image = image
        self.assignedProduct = assignedProduct
    }
}
