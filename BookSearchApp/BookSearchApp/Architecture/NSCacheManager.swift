//
//  NSCacheManager.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

class NSCacheManager {
    static private let memoryCache = NSCache<NSString, UIImage>()
    static private let fileManager = FileManager.default
    static private var imageData: Data?
    
    private init() { }
        
    // MARK: - Cache 이미지 Load
    static func imageLoadCache(urlString: String) -> UIImage? {
        guard let imageURL = URL(string: urlString) else { return nil }
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else { return nil }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        if let cachedImage = memoryCache.object(forKey: filePath.lastPathComponent as NSString) { // 메모리에 이미지 파일 있으면 반환
            print("캐시 메모리에 있는 이미지를 반환")
            
            return cachedImage
        } else if fileManager.fileExists(atPath: filePath.path) { // 메모리에 캐시 파일 없고 디스크 경로에 있으면 이미지 반환
            imageData = try? Data(contentsOf: filePath)
            
            guard let imageData = imageData else { return nil }
            guard let uIImage = UIImage(data: imageData) else { return nil }
            
            imageSetMemory(image: uIImage, urlString: urlString) // 메모리 영역에 캐시파일 저장
            print("디스크에 있는 이미지를 반환")
            
            return uIImage
        }
        
        return nil // 기기에 캐시 파일 존재하지 않음
        
    }
    
    // MARK: - NSCache 이미지 저장
    static func imageSetMemory(image: UIImage, urlString: String) {
        guard let imageURL = URL(string: urlString) else { return }
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else { return }
        
        var filePath = URL(fileURLWithPath: cachesDir)
        filePath.appendPathComponent(imageURL.lastPathComponent)

        self.memoryCache.setObject(image, forKey: filePath.lastPathComponent as NSString)
    }
    
    // MARK: - DiskCache 이미지 저장
    static func imageSetDisk(image: UIImage, urlString: String) {
        guard let imageURL = URL(string: urlString) else { return }
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else { return }
        
        var filePath = URL(fileURLWithPath: cachesDir)
        filePath.appendPathComponent(imageURL.lastPathComponent)

        fileManager.createFile(atPath: filePath.path, contents: image.jpegData(compressionQuality: 0.4))
    }
    
}
