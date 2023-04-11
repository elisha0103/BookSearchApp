//
//  ContentView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookSearchViewModel: BookSearchViewModel
    private let urlString: String = "https://openlibrary.org/search.json?q=the+lord+of+the+rings"
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // MARK: - Grid View
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(bookSearchViewModel.searchBooksResult.books, id: \.self) { book in
                            BookCellView(
                                bookTitle: book.title,
                                authors: book.authorName,
                                ratingAverage: book.ratingsAverage,
                                coverID: book.coverI
                            )
                            .frame(width: 150, height: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, 1)
                    .padding(.bottom, 120)
                }
            }
            .padding()
            .onAppear {
                Task {
                    try await bookSearchViewModel.fetchBooksData(url: urlString)
                }
            } // VStack
        } // NavigationView
    } // body
} // ContentView

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
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                Text("\(bookTitle)")
                    .font(.headline)
                    .lineLimit(2)
                Text("\(presentAuthors)")
                    .font(.subheadline)
                    .lineLimit(2)
                HStack {
                    Text("\(presentRatingAverage)")
                        .font(.footnote)
                    if ratingAverage != nil {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10)
                    }
                } // HStack
            } // VStack
        } // VStack
    } // body
} // BookCellView

// struct BookCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookCellView(
//            bookTitle: "BookTitleBookTitleBookTitleBookTitleBookTitleBookTitleBookTitleBookTitleBookTitleBookTitle",
//            authors: ["author, author, author, author, author, author, author, author, author, author, author"],
//            ratingAverage: 3.12135,
//            coverID: 2,
//            thumbnailImage: Image(systemName: "book.closed")
//        )
//    }
// }

 struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookSearchViewModel(searchBooksResult: SearchBooksResult(numFound: 0, books: [])))
    }
 }
