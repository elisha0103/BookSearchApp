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
    let key: String                                                         // Book Key
    let title: String                                                       // 책 제목
    let authorName: [String]?                                               // 작가 배열
    let coverI: Int?                                                        // 썸네일 이미지 코드
    let ratingsAverage: Double?                                             // 평점
    let ratingsCount, ratingsCount1, ratingsCount2, ratingsCount3: Int?     // 총 리뷰 수, 1점 수, 2점 수, 3점 수
    let ratingsCount4, ratingsCount5: Int?                                  // 4점 수, 5점 수
    let numberOfPagesMedian: Int?                                           // 책 페이지 수
                                            
    // MARK: - 옵셔널 변수에 대한 연산 프로퍼티
    var presentAuthors: String {  // 작가 배열을 String으로 반환하는 변수
        guard let authors = self.authorName else { return "작가 미상" }
        var names: String = authors[0]
        for index in 1..<authors.count {
            names = "\(names), \(authors[index])"
        }
        return names
    }
    
    var presentRatingAverage: String { // 평점 소수점 셋째 자리에서 반올림하여 문자열로 반환하는 변수
        let digit: Double = pow(10, 2)
        
        guard let ratingAverage = self.ratingsAverage else { return "" }
        
        return String(format: "%.1f", round(ratingAverage * digit) / digit)
    }
    
    var presentNumberOfPageMedian: String { // 페이지 수를 반환하는 변수
        guard let numberOfPagesMedian = self.numberOfPagesMedian else { return "" }
        
        return String("\(numberOfPagesMedian)페이지")
    }
    
    var presentRatingCount: [Int] { // 리뷰 정보를 반환하는 변수
        var ratingArr: [Int] = Array(repeating: 0, count: 6)
        guard
            let ratingsCount = self.ratingsCount,
            let ratingsCount1 = self.ratingsCount1,
            let ratingsCount2 = self.ratingsCount2,
            let ratingsCount3 = self.ratingsCount3,
            let ratingsCount4 = self.ratingsCount4,
            let ratingsCount5 = self.ratingsCount5
        else { return [0, 0, 0, 0, 0, 0] }
        
        ratingArr[0] = ratingsCount     // Index 0: 전체 평점 수
        ratingArr[1] = ratingsCount1    // Index 1: 1점 수
        ratingArr[2] = ratingsCount2    // Index 2: 2점 수
        ratingArr[3] = ratingsCount3    // Index 3: 3점 수
        ratingArr[4] = ratingsCount4    // Index 4: 4점 수
        ratingArr[5] = ratingsCount5    // Index 5: 5점 수
        
        return ratingArr
    }
    
    enum CodingKeys: String, CodingKey {
        case key, title
        case authorName = "author_name"
        case coverI = "cover_i"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case ratingsCount1 = "ratings_count_1"
        case ratingsCount2 = "ratings_count_2"
        case ratingsCount3 = "ratings_count_3"
        case ratingsCount4 = "ratings_count_4"
        case ratingsCount5 = "ratings_count_5"
        case numberOfPagesMedian = "number_of_pages_median"
        
    }
}
