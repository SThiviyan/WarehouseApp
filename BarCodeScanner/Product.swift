//
//  Product.swift
//  BarCodeScanner
//
//  Created by Thiviyan Saravanamuthu on 11.03.25.
//

import Foundation
import UIKit


class Product
{
    var productname: String
    var price: String
    var size : String
    var category: String
    var image: UIImage
    var producer: String
    
    
    init(productname: String, price: String, size: String, category: String, image: UIImage, producer: String) {
        self.productname = productname
        self.price = price
        self.size = size
        self.category = category
        self.image = image
        self.producer = producer
    }
}


