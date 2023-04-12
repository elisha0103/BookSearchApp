//
//  WebService.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

final class WebService {
    static private let session = URLSession.shared
    static private let searchAPIURL = Bundle.main.searchAPILink // APILinkList.plist Search_API_Link 값
    static private let coversAPIURL = Bundle.main.coversAPILink // APILinkList.plist Covers_API_Link 값
    
    // MARK: - 책 fetch 함수
    static func fetchBooksData(keyWords: String, page: Int) async throws -> SearchBooksResult {
       let requestURL: String = "\(searchAPIURL)\(keyWords)&page=\(page)"
        
        print("요청 링크: \(requestURL)")
        
       guard let url = URL(string: requestURL) else {
           print("요청 URL이 잘못됐습니다.")
           
           return SearchBooksResult(numFound: 0, books: [])
       }
       
       let (data, _) = try await session.data(from: url)
       
       let searchResult = try JSONDecoder().decode(SearchBooksResult.self, from: data)
       
       return searchResult
   }

    // MARK: - Cover 이미지 fetch 함수
    static func fetchCoverImage(coverCode: Int?, size: String) async throws -> UIImage? {
        guard let coverCode = coverCode else { return nil }
        
        let requestURL: String = "\(coversAPIURL)\(coverCode)-\(size).jpg" // API Request URL String
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return nil
        }
        
        if let cachedImage = NSCacheManager.imageLoadCache(urlString: requestURL) { // 기기 메모리 혹은 디스크로부터 이미지 호출
            print("이미지 캐시 반환")
            
            return cachedImage
        } else { // 기기에 캐시 파일 없으면 서버로부터 load
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            // 서버로 로드된 파일을 기기 메모리, disk 영역에 저장
            NSCacheManager.imageSetDisk(image: image, urlString: requestURL)
            NSCacheManager.imageSetMemory(image: image, urlString: requestURL)
            
            print("api 서버 이미지 반환")
            return image
        }
        
    }
}
