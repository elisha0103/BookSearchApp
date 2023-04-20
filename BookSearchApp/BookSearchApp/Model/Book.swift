//
//  SearchResult.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

struct Book: Codable, Hashable {
    let key: String                                                         // Book Key
    var title: String                                                       // 책 제목
    var authorName: [String]?                                               // 작가 배열
    var coverI: Int?                                                        // 썸네일 이미지 코드
    var ratingsAverage: Double?
    var ratingsCount, ratingsCount1, ratingsCount2, ratingsCount3: Int?     // 총 리뷰 수, 1점 수, 2점 수, 3점 수
    var ratingsCount4, ratingsCount5: Int?                                  // 4점 수, 5점 수
    var numberOfPagesMedian: Int?                                            // 책 페이지 수
    
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
