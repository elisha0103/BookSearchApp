//
//  SearchViewModel.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation
import Combine

final class BookSearchViewModel: ObservableObject {
    @Published var searchBooksResult: SearchBooksResult
   // @Published var searchString: String = ""    // 타이핑 검색 때 사용
    @Published var loadingBooksDataState: LoadingState = .done {
        didSet {
            print("state changed to: \(loadingBooksDataState)")
        }
    }
    
    var page = 1
    
    // TODO: - AnyCancellable
//    var subscriptions = Set<AnyCancellable>()
    
    enum LoadingState: Comparable {
        case done
        case isLoading
        case loadedAll
        case error(String)
    }
    
    init(searchBooksResult: SearchBooksResult) {
        self.searchBooksResult = searchBooksResult
        
        //        $searchString
        //            .dropFirst()
        //            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        //            .sink{ [ unowned self ] term in
        //                Task {
        //                    self.loadingBooksDataState = .done
        //                    self.searchBooksResult.books = []
        //                    try await self.fetchBooksData(keywords: term)
        //                }
        //            }.store(in: &subscriptions)
        
    }
    
    // MARK: - ViewModel 정보 초기화
    func resetViewModelData() {
        self.loadingBooksDataState = .done
        self.searchBooksResult.numFound = 0
        self.searchBooksResult.books = []
        self.page = 1
    }
    
    // MARK: - 도서 검색 함수
    func fetchBooksData(searchString: String) async throws {
        
        let searchStringWithOutSpace = searchString
            .trimmingCharacters(in: [" "]) // 문자열 양 끝단 공백 제거
            .replacingOccurrences(of: " ", with: "+") // 문자열 사이 공백 "+"로 치환

        guard !searchStringWithOutSpace.isEmpty else { return }
        
        guard loadingBooksDataState == LoadingState.done else { return }
        // 데이터 fetch 중에 연속적인 fetch, 데이터의 끝, 에러 상황에서 호출 방지
        
        do {
            print("viewmodel start fetch")
            
            let result = try await WebService.fetchBooksData(keyWords: searchStringWithOutSpace, page: self.page)
            
            print("현재 페이지: \(self.page)")

            print("finish fetch")
            DispatchQueue.main.async {
                var fetchBooks: [Book] = []
                
                self.loadingBooksDataState = .isLoading
                
                self.searchBooksResult.numFound = result.numFound

                for book in result.books {
                    fetchBooks.append(book)
                }
                self.searchBooksResult.books.append(contentsOf: fetchBooks)
                
                self.loadingBooksDataState = (self.searchBooksResult.books.count == self.searchBooksResult.numFound) ?
                    .loadedAll : .done
                if self.loadingBooksDataState == .loadedAll {
                    print("데이터의 끝입니다. books: \(self.searchBooksResult.books.count)")
                }
            }
            self.page += 1
        } catch let error as NSError {
            print("JSON fetch Error: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.loadingBooksDataState = .error("Could not load: \(error.localizedDescription)")
            }
        }
    }
}
