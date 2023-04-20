//
//  SearchBooksResultPModel.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/19.
//

import Foundation

struct SearchBooksResultPModel {
    var numFound: Int
    var books: [BookPModel]
    
    static func converTo(_ searchBooksResult: SearchBooksResult) -> SearchBooksResultPModel {
        return SearchBooksResultPModel(
            numFound: searchBooksResult.numFound,
            books: searchBooksResult.books.map({ book in
                return BookPModel.convert(book)
            })
        )
    }
}
