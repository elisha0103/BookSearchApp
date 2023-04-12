//
//  NSCacheManager.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

class NSCacheManager {
    private init() { }
    
    static private let storage = NSCache<NSString, UIImage>()
    
    static func cachedImage(urlString: String) -> UIImage? {
        let cachedKey = NSString(string: urlString)
        if let cachedImage = storage.object(forKey: cachedKey) {
            return cachedImage
        }
        
        return nil
    }
    
    static func setObject(image: UIImage, urlString: String) {
        let forKey = NSString(string: urlString)
        self.storage.setObject(image, forKey: forKey)
    }
}
