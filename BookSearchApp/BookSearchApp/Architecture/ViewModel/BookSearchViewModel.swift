//
//  SearchViewModel.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation
import Combine

final class BookSearchViewModel: ObservableObject {
    // MARK: - Properties
    @Published var searchBooksResultPModel: SearchBooksResultPModel
    @Published var loadingBooksDataState: LoadingState = .done {
        didSet {
            print("state changed to: \(loadingBooksDataState)")
        }
    }
    
    var page = 1
    
    enum LoadingState: Comparable {
        case done
        case isLoading
        case loadedAll
        case error(String)
    }
    
    // MARK: - Initializers
    init(searchBooksResultPModel: SearchBooksResultPModel) {
        self.searchBooksResultPModel = searchBooksResultPModel
    }
    
    // MARK: - Methods
    func resetViewModelData() {
        self.loadingBooksDataState = .done
        self.searchBooksResultPModel.numFound = 0
        self.searchBooksResultPModel.books = []
        self.page = 1
    }
    
    func fetchBooksData(searchString: String) async {
        
        let searchStringWithOutSpace = searchString
            .trimmingCharacters(in: [" "])
            .replacingOccurrences(of: " ", with: "+")
        
        guard !searchStringWithOutSpace.isEmpty,
              loadingBooksDataState == LoadingState.done
        else { return }
        // 데이터 fetch 중에 연속적인 fetch, 데이터의 끝, 에러 상황에서 호출 방지
        
        do {
            print("viewmodel start fetch")
            DispatchQueue.main.sync {
                self.loadingBooksDataState = .isLoading
            }
            let result = try await WebService.fetchBooksData(keyWords: searchStringWithOutSpace, page: self.page)
            
            print("현재 페이지: \(self.page)")
            
            print("finish fetch")
                        
            DispatchQueue.main.async { [weak self] in
                self?.searchBooksResultPModel.numFound = result.numFound

                self?.searchBooksResultPModel.books.append(contentsOf: result.books)
                
                self?.loadingBooksDataState =
                (self?.searchBooksResultPModel.books.count == self?.searchBooksResultPModel.numFound) ?
                    .loadedAll : .done
                if self?.loadingBooksDataState == .loadedAll {
                    print("데이터의 끝입니다. books: \(self?.searchBooksResultPModel.books.count ?? -1)")
                }
                self?.page += 1
            }
        } catch let error as NSError {
            print("JSON fetch Error: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.loadingBooksDataState = .error("Could not load: \(error.localizedDescription)")
            }
        }
    }
}
