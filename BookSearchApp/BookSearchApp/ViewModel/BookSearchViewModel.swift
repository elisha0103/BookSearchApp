//
//  SearchViewModel.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

final class BookSearchViewModel: ObservableObject {
    @Published var searchBooksResult: SearchBooksResult

    init(searchBooksResult: SearchBooksResult) {
        self.searchBooksResult = searchBooksResult
    }

    func fetchBooksData(url: String) async throws {
        do {
            print("viewmodel start fetch")
            let result = try await WebService.fetchBooksData(url: url)
            print("finish fetch")
            DispatchQueue.main.async {
                self.searchBooksResult = result
            }
        } catch let error as NSError {
            print("JSON fetch Error: \(error.localizedDescription)")
        }
    }
}
