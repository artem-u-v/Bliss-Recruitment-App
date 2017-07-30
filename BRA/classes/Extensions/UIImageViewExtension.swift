//
//  UIImageViewExtension.swift
//  BRA
//
//  Created by Artem Umanets on 30/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageAsync(withUrl url: URL, completion:@escaping(_ image:UIImage?, _ error:Error?) -> Void) {
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            completion(cachedImage, nil)
            return
        }
        
        // if not cached, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else{
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image
                    completion(image, nil)
                }
            }
        }).resume()
    }
}
