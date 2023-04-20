//
//  BookSellView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct BookCellView: View {
    @Binding var bookTitle: String       // 책 제목
    var presentAuthors: String  // 작가
    var presentRatingAverage: String   // 책 평점
    @Binding var coverID: Int?       // 책 썸네일 이미지 코드
    
    var body: some View {
        VStack {
            CoverImageView(coverImageViewModel: CoverImageViewModel(uIImage: nil, coverCode: coverID))
            
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
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(width: 175, height: 250)
        
    } 
}
