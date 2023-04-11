//
//  ContentView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookSearchViewModel: BookSearchViewModel
    @State var searchString: String = ""
    @State private var loadingState: Bool = false // ProgressView 출력용
    private let searchAPIURL: String = Bundle.main.searchAPILink // APILinkList.plist Search_API_Link 값
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        TextField("도서 검색", text: $searchString, onCommit: {
                            
                            let text = searchString
                                .trimmingCharacters(in: [" "]) // 문자열 양 끝단 공백 제거
                                .replacingOccurrences(of: " ", with: "+") // 문자열 사이 공백 "+"로 치환
                            let resultURL: String = "\(searchAPIURL)\(text)"
                            
                            Task {
                                loadingState.toggle()
                                try await bookSearchViewModel.fetchBooksData(url: resultURL)
                                print("finish view fetch")
                                loadingState.toggle()
                            }
                            
                        })
                        .disableAutocorrection(true) // 자동 교정 비활성화
                        .autocapitalization(.none)  // 자동 대문자 변환 비활성화
                        .padding(.bottom, 10)
                        .cornerRadius(10)
                        .modifier(TextFieldClearButton(fieldText: $searchString))
                        Spacer()
                    }
                    .frame(height: 15)
                    
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
                                //                            .overlay(
                                //                                RoundedRectangle(cornerRadius: 20)
                                //                                    .stroke(Color.gray, lineWidth: 2)
                                //                            )
                            }
                        }
                        .padding(.horizontal, 5)
                        .padding(.top, 1)
                        .padding(.bottom, 120)
                    }
                }
                .padding()
                .onAppear {
                    //                Task {
                    //                    try await bookSearchViewModel.fetchBooksData(url: urlString)
                    //                }
                } // VStack
            } // NavigationView
            if loadingState {
                ProgressView()
            }

        } // ZStack
    } // body
} // ContentView

 struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookSearchViewModel(searchBooksResult: SearchBooksResult(numFound: 0, books: [])))
    }
 }