//
//  BookSellView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct BookCellView: View {
    let bookTitle: String       // 책 제목
    let presentAuthors: String  // 작가
    let presentRatingAverage: String   // 책 평점
    let coverID: Int?       // 책 썸네일 이미지 코드
    
    init(bookTitle: String, presentAuthors: String, presentRatingAverage: String, coverID: Int?) {
        self.bookTitle = bookTitle
        self.presentAuthors = presentAuthors
        self.presentRatingAverage = presentRatingAverage
        self.coverID = coverID
    } // init
    
    var body: some View {
        VStack {
            CoverImageView(coverCode: coverID)
//            Image(systemName: "book.closed")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 100, height: 180)
//                .shadow(radius: 6)
            
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
                        if !presentRatingAverage.isEmpty {
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 10)
                        }
                        Text("\(coverID ?? 0)")
                    } // HStack
                    
                    Spacer()
                    
                } // VStack
                .frame(maxWidth: .infinity, alignment: .leading)

        } // VStack
        .frame(width: 175, height: 250)
        
    } // body
} // BookCellView