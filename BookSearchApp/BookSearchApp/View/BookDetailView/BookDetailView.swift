//
//  BookDetailView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct BookDetailView: View {
    @State var book: Book
    
    var body: some View {
        VStack {
            ScrollView {
                // MARK: - 책 기본 정보
                HStack(alignment: .top) {
                    CoverImageView(coverCode: book.coverI)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text("\(book.title)")
                        .font(.footnote)
                        .lineLimit(5)
                    Text("\(book.presentAuthors)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(book.presentNumberOfPageMedian)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                
                Divider()
                
                Spacer(minLength: 30)
                
                // MARK: - 평점
                
                VStack {
                    Text("평점")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                    
                    HStack {
                        VStack(alignment: .center, spacing: 10) { // 왼쪽
                            // 평점이 없는 경우, 0으로 표시
                            Text("\(book.presentRatingAverage.isEmpty ? "0" : book.presentRatingAverage)")
                                .font(.system(size: 45))
                                .bold()
                            
                            Text("평점 \(book.presentRatingCount[0])개")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } // VStack
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) { // 오른쪽
                            RatingBarView(
                                ratingNumber: 5,
                                ratingNumberCount: book.presentRatingCount[5],
                                ratingTotalNumber: book.presentRatingCount[0]
                            )
                            
                            RatingBarView(
                                ratingNumber: 4,
                                ratingNumberCount: book.presentRatingCount[4],
                                ratingTotalNumber: book.presentRatingCount[0]
                            )
                            
                            RatingBarView(
                                ratingNumber: 3,
                                ratingNumberCount: book.presentRatingCount[3],
                                ratingTotalNumber: book.presentRatingCount[0]
                            )
                            
                            RatingBarView(
                                ratingNumber: 2,
                                ratingNumberCount: book.presentRatingCount[2],
                                ratingTotalNumber: book.presentRatingCount[0]
                            )
                            
                            RatingBarView(
                                ratingNumber: 1,
                                ratingNumberCount: book.presentRatingCount[1],
                                ratingTotalNumber: book.presentRatingCount[0]
                            )
                            
                        } // VStack
                        .frame(maxWidth: .infinity)
                    } // HStack
                } // VStack
                Spacer(minLength: 250)
            }
        } // VStack
        .padding()
    } // body
    
    // MARK: - 평점 점수별 Progress Bar
    struct RatingBarView: View {
        var ratingNumber: Int           // 점수
        var ratingNumberCount: Int      // 해당 점수 투표 수
        var ratingTotalNumber: Int      // 전체 투표 수
        
        init(ratingNumber: Int, ratingNumberCount: Int, ratingTotalNumber: Int) {
            self.ratingNumber = ratingNumber
            self.ratingNumberCount = ratingNumberCount
            self.ratingTotalNumber = ratingTotalNumber
        }
        
        var body: some View {
            HStack {
                Text("\(ratingNumber)")
                    .font(.caption)
                    .bold()
                
                // 리뷰가 없는 경우, 0 / 100을 하기 위해서 TotalNumber 조건문을 통해 임시 값 100을 대입
                ProgressView(
                    value: Double(ratingNumberCount),
                    total: ratingTotalNumber == 0 ? 100 : Double(ratingTotalNumber)
                )
                .scaleEffect(x: 1, y: 2.5, anchor: .center)
                
            } // HStack
            .padding(.horizontal, 10)
        } // body
    } // RatingBarView
} // BookDetailView

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book(
            key: "key",
            title: "Book_Title",
            authorName: ["author", "author", "author"],
            coverI: 123123,
            ratingsAverage: 4.515625,
            ratingsCount: 64,
            ratingsCount1: 2,
            ratingsCount2: 2,
            ratingsCount3: 6,
            ratingsCount4: 5,
            ratingsCount5: 49,
            numberOfPagesMedian: 1193
        ))
    }
}
