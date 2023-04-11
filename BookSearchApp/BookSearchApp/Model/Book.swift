//
//  SearchResult.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

struct SearchBooksResult: Codable {
    let numFound: Int
    let books: [Book]
    enum CodingKeys: String, CodingKey {
        case numFound
        case books = "docs"
    }
}

struct Book: Codable, Hashable {
    let key: String
    let title: String
    let authorName: [String]?
    let coverI: Int?
    let ratingsAverage: Double?

    enum CodingKeys: String, CodingKey {
        case key, title
        case authorName = "author_name"
        case coverI = "cover_i"
        case ratingsAverage = "ratings_average"
    }
}
