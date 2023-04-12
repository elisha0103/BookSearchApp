//
//  WebService.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

final class WebService {
    static private let searchAPIURL = Bundle.main.searchAPILink // APILinkList.plist Search_API_Link 값
   // static private let coversAPIURL = bundle.main.coversAPILink // APILinkList.plist Covers_API_Link 값


    // MARK: - 책 fetch 함수
   static func fetchBooksData(keyWords: String) async throws -> SearchBooksResult {
       let resultURL: String = "\(searchAPIURL)\(keyWords)"

       guard let url = URL(string: resultURL) else { return SearchBooksResult(numFound: 0, books: []) }

       print("fetchData")
       
       let (data, _) = try await URLSession.shared.data(from: url)
       
       let searchResult = try JSONDecoder().decode(SearchBooksResult.self, from: data)
       
       return searchResult
   }

    /*
    static private func fetchCoverImage(url: String) async throws -> {
        
    }
     */
}
