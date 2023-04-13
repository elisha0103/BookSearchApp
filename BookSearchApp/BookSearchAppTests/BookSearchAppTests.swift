//
//  BookSearchAppTests.swift
//  BookSearchAppTests
//
//  Created by 진태영 on 2023/04/13.
//

import XCTest
@testable import BookSearchApp

final class BookSearchAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        try super.tearDownWithError()
    }
    
    // MARK: - 메모리에 캐시 데이터 저장
    func testSetImageInMemoryCache() throws {
        var image = UIImage(systemName: "book.closed")
        let memoryCache = NSCache<NSString, UIImage>()
        let imageURL = URL(string: "book.closed")!
        
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else {
            print("캐시 디렉토리 없음")
            return
        }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        CacheManager.imageSetMemory(image: image!, urlString: "book.closed")
        
        let loadImage = CacheManager.imageLoadCache(urlString: "book.closed")
        XCTAssertTrue(((loadImage?.isEqual(image)) != nil), "이미지 저장에 실패했습니다.")
            
    }
    
    // MARK: - 디스크에 캐시 데이터 저장
    func testsetImageInDiskCache() throws {
        var image = UIImage(systemName: "book.closed")
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
        
         let loadImage = CacheManager.imageLoadCache(urlString: "book.closed")
        XCTAssertTrue(((loadImage?.isEqual(image)) != nil), "이미지 저장에 실패했습니다.")

    }
    
    // MARK: - 캐시 로드 함수
    func testloadImageFromCache() throws {
        var image = UIImage(systemName: "book.closed")
        var loadImage: UIImage?
        
        loadImage = CacheManager.imageLoadCache(urlString: "book.closed")
        
        XCTAssertTrue(loadImage != nil, "이미지 호출에 실패했습니다.")
    }
    
    // MARK: - 디버깅을 위한 Cache 삭제함수
    func testdeleteImageMemoryCache() throws {
        let memoryCache = NSCache<NSString, UIImage>()
        let imageURL = URL(string: "book.closed")!
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else {
            print("캐시 디렉토리 없음")
            return
        }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        memoryCache.removeObject(forKey: filePath.lastPathComponent as NSString)
        
    }
    
    func testdeleteImageDiskCache() throws {
        let fileManager = FileManager.default
        let imageURL = URL(string: "book.closed")!
        
        guard let cachesDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else {
            print("캐시 디렉토리 없음")
            return
        }
        
        var filePath = URL(fileURLWithPath: cachesDir) // 기본 캐시 디렉토리를 경로로 설정
        filePath.appendPathComponent(imageURL.lastPathComponent)
        
        try fileManager.removeItem(atPath: filePath.path)

    }
    
}
