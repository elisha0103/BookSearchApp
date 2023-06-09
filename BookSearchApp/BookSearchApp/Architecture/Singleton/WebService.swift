//
//  WebService.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

final class WebService {
    static private let session = URLSession.shared
    static private let searchAPIURL = "https://openlibrary.org/search.json?q=" // Search_API
    static private let coversAPIURL = "https://covers.openlibrary.org/b/id/" // Covers_API 값
    
    // MARK: - 책 fetch 함수
    static func fetchBooksData(keyWords: String, page: Int) async throws -> SearchBooksResultPModel {
        let requestURL: String = "\(searchAPIURL)\(keyWords)&page=\(page)"
        
        print("요청 링크: \(requestURL)")
        
        guard let url = URL(string: requestURL) else {
            print("요청 URL이 잘못됐습니다.")
            
            return SearchBooksResultPModel(numFound: 0, books: [])
        }
        
        let (data, _) = try await session.data(from: url)
        
        let searchResult = try JSONDecoder().decode(SearchBooksResult.self, from: data)
        
        return SearchBooksResultPModel.converTo(searchResult)
    }
    
    // MARK: - Cover 이미지 fetch 함수
    static func fetchCoverImage(coverCode: Int?, size: String) async throws -> UIImage? {
        let start = CFAbsoluteTimeGetCurrent()
        guard let coverCode = coverCode else { return nil }
        
        let requestURL: String = "\(coversAPIURL)\(coverCode)-\(size).jpg"
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return nil
        }
        
        if let cachedImage = CacheManager.imageLoadCache(urlString: requestURL) { // 기기 메모리 혹은 디스크로부터 이미지 호출
            print("이미지 캐시 반환")
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("캐시 로드 시간: \(diff)")
            return cachedImage
        } else { // 기기에 캐시 파일 없으면 서버로부터 load
            let urlRequest = URLRequest(url: url)
            if session.dataTask(with: urlRequest).state == URLSessionTask.State.running {
                
            }
            
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("서버 로드 시간: \(diff)")
            // 서버로 로드된 파일을 기기 메모리, disk 영역에 저장
            CacheManager.imageSetDisk(image: image, urlString: requestURL)
            CacheManager.imageSetMemory(image: image, urlString: requestURL)
            
            print("api 서버 이미지 반환")
            return image
        }
        
    }
}
