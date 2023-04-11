//
//  WebService.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

final class WebService {

    // MARK: - 책 fetch 함수
   static func fetchBooksData(url: String) async throws -> SearchBooksResult {
       guard let url = URL(string: url) else { return SearchBooksResult(numFound: 0, books: []) }

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
