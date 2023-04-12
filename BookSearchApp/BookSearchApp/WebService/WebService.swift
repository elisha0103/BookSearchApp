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
   static func fetchBooksData(keyWords: String) async throws -> SearchBooksResult {
       let requestURL: String = "\(searchAPIURL)\(keyWords)"

       guard let url = URL(string: requestURL) else { return SearchBooksResult(numFound: 0, books: []) }
       
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
        
        if let cachedImage = NSCacheManager.cachedImage(urlString: requestURL) {
            return cachedImage
        } else {
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            NSCacheManager.setObject(image: image, urlString: requestURL)
            
            return image
        }
        
    }
}
