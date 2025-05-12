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
    var app: App = App.shared
    @Published var ImageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

    
    init(){
      
        
    }
    
    
    func prefetch(urls: [String])
    {
        
        print("===========PREFETCHING IMAGES==================")
        for url in urls
        {
            DispatchQueue.global(qos: .userInitiated).async
            {
                if let cachedImage = self.ImageCache.object(forKey: url as NSString)
                {
                    print("image exists in cache")
                }
                else
                {
                    if let image = self.app.getImage(url: url)
                    {
                        self.ImageCache.setObject(image, forKey: url as NSString)
                        
                        print("image downloaded and cached")
                    }
                }
                
            }
        }

    }
    
    
    func getImage(url: String?) -> UIImage?
    {
        if(url != nil)
        {
            if let cachedImage = self.ImageCache.object(forKey: url! as NSString)
            {
                return cachedImage
            }
        }
        
        return nil
    }
}

