//
//  BookSellView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct BookCellView: View {
    let bookTitle: String       // 책 제목
    let authors: [String]?      // 작가
    let ratingAverage: Double?      // 책 평점
    let coverID: Int?       // 책 썸네일 이미지 코드
    var presentAuthors: String {  // 작가 배열을 String으로 반환하는 변수
        guard let authors = self.authors else { return "작가 미상" }
        var names: String = authors[0]
        for index in 1..<authors.count {
            names = "\(names), \(authors[index])"
        }
        return names
    }
    var presentRatingAverage: String { // 평점 반올림해서 문자열로 반환하는 변수
        let digit: Double = pow(10, 2)
        
        guard let ratingAverage = self.ratingAverage else { return "" }
        
        return String(format: "%.1f", round(ratingAverage * digit) / digit)
    }
    
    init(bookTitle: String, authors: [String]?, ratingAverage: Double?, coverID: Int?) {
        self.bookTitle = bookTitle
        self.authors = authors
        self.ratingAverage = ratingAverage
        self.coverID = coverID
    } // init
    
    var body: some View {
        VStack {
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 180)
                .shadow(radius: 6)
            
            Spacer()
            
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(bookTitle)")
                        .font(.footnote)
                        .bold()
                        .lineLimit(2)
                    Text("\(presentAuthors)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    HStack {
                        Text("\(presentRatingAverage)")
                            .font(.caption2)
                        if ratingAverage != nil {
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 10)
                        }
                    } // HStack
                    
                    Spacer()
                    
                } // VStack
                .frame(maxWidth: .infinity, alignment: .leading)

        } // VStack
        .frame(width: 175, height: 250)
        
    } // body
} // BookCellView
