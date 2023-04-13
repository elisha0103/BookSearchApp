//
//  SearchBooksResult.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/13.
//

import Foundation

struct SearchBooksResult: Codable {
    var numFound: Int
    var books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case numFound
        case books = "docs"
    }
}
