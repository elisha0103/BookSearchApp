//
//  BookSearchAppTests.swift
//  BookSearchAppTests
//
//  Created by 진태영 on 2023/04/13.
//

import XCTest
@testable import BookSearchApp

final class BookSearchAppTests: XCTestCase {
    
    // MARK: - Methods
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
    }
        
    func testloadImageFromCache() throws {
        var loadImage: UIImage?
        var image = UIImage(systemName: "book.closed")
        let memoryCache = NSCache<NSString, UIImage>()
        var fileManager = FileManager.default
        let imageURL = URL(string: "book.closed")!
        
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else {
            print("캐시 디렉토리 없음")
            return
        }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        
        CacheManager.imageSetDisk(image: image!, urlString: "book.closed")
        var diskLoadImage: UIImage? = CacheManager.imageLoadCache(urlString: "book.closed")
        XCTAssertTrue(diskLoadImage != nil, "디스크 이미지 호출에 실패했습니다.")
        
        try fileManager.removeItem(atPath: filePath.path)
        
        CacheManager.imageSetMemory(image: image!, urlString: "book.closed")
        var memoryLoadImage: UIImage? = CacheManager.imageLoadCache(urlString: "book.closed")
        XCTAssertTrue(memoryLoadImage != nil, "메모리 이미지 호출에 실패했습니다.")
        
        memoryCache.removeObject(forKey: filePath.lastPathComponent as NSString)
        
        
    }
        
}
