//
//  NSCacheManager.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

final class CacheManager {
    static private let memoryCache = NSCache<NSString, UIImage>()
    static private let fileManager = FileManager.default
    static private var imageData: Data?
    
    private init() { }
    
    // MARK: - Cache 이미지 Load
    static func imageLoadCache(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        
        guard let filePath = makeCachePath(urlString: urlString) else { return }
        WebService.checkImageUpdate(imageUrl: urlString) { isNeedUpdate, image in // Etag 검사 request server에 전송
            if isNeedUpdate {
                print("DEBUG: API 서버 이미지 반환")
                let diff = CFAbsoluteTimeGetCurrent() - start
                print("서버 로드 시간: \(diff)")
                
                completion(image) // 서버 다운 이미지 전달
            } else {    // 메모리에 이미지 파일 있으면 반환
                if let cachedImage = memoryCache.object(forKey: filePath.lastPathComponent as NSString) {
                    print("캐시 메모리에 있는 이미지를 반환")
                    let diff = CFAbsoluteTimeGetCurrent() - start
                    print("메모리 캐시 로드 시간: \(diff)")
                    
                    completion(cachedImage)
                } else if fileManager.fileExists(atPath: filePath.path) { // 메모리에 캐시 파일 없고 디스크 경로에 있으면 이미지 반환
                    imageData = try? Data(contentsOf: filePath)
                    
                    guard let imageData = imageData else { return }
                    guard let uIImage = UIImage(data: imageData) else { return }
                    
                    imageSetMemory(image: uIImage, urlString: urlString) // 메모리 영역에 캐시파일 저장
                    print("디스크에 있는 이미지를 반환")
                    let diff = CFAbsoluteTimeGetCurrent() - start
                    print("디스크 캐시 로드 시간: \(diff)")
                    
                    completion(uIImage)
                }
                
            }
        }
        
    }
    
    // MARK: - NSCache 이미지 저장
    static func imageSetMemory(image: UIImage, urlString: String) {
        guard let filePath = makeCachePath(urlString: urlString) else { return }
        self.memoryCache.setObject(image, forKey: filePath.lastPathComponent as NSString)
    }
    
    // MARK: - DiskCache 이미지 저장
    static func imageSetDisk(image: UIImage, urlString: String, etag: String) {
        guard let filePath = makeCachePath(urlString: urlString) else { return }
        guard let url = URL(string: urlString) else { return }
        fileManager.createFile(atPath: filePath.path, contents: image.jpegData(compressionQuality: 0.4))
        UserDefaults.standard.set(etag, forKey: url.path)
    }
    
    static func makeCachePath(urlString: String) -> URL? {
        guard let imageURL = URL(string: urlString),
              let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else { return nil }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        return filePath
    }
}
