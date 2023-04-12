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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    // MARK: - 도서 검색 View
                    HStack {
                        TextField("도서 검색", text: $searchString, onCommit: {
                            
                            bookSearchViewModel.resetViewModelData() // 새로 검색하면 ViewModel 검색상태 초기화
                            
                            Task {
                                loadingState.toggle()
                                try await bookSearchViewModel.fetchBooksData(searchString: searchString)
                                loadingState.toggle()
                            }
                            
                        })
                        .disableAutocorrection(true) // 자동 교정 비활성화
                        .autocapitalization(.none)  // 자동 대문자 변환 비활성화
                        .padding(.bottom, 10)
                        .cornerRadius(10)
                        .modifier(TextFieldClearButton(fieldText: $searchString)) // Clear 버튼
                        Spacer()
                    }
                    .frame(height: 15)
                    
                    // MARK: - 도서 검색 결과 View
                    Text("검색 결과: \(bookSearchViewModel.searchBooksResult.numFound)개")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(bookSearchViewModel.searchBooksResult.books, id: \.self) { book in
                                NavigationLink {
                                    BookDetailView(book: book)
                                } label: {
                                    BookCellView(
                                        bookTitle: book.title,
                                        presentAuthors: book.presentAuthors,
                                        presentRatingAverage: book.presentRatingAverage,
                                        coverID: book.coverI
                                    )
                                }
                                .accentColor(.black)
                            } // ForEach
                            
                            // MARK: - Pagenation
                            if !loadingState { // 검색 중에는 페이지네이션 동작 제한
                                switch bookSearchViewModel.loadingBooksDataState {
                                case .done:
                                    Color.clear
                                        .onAppear {
                                            Task {
                                                try await bookSearchViewModel.fetchBooksData(searchString: searchString)
                                            }
                                        }
                                case .isLoading:
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                case .loadedAll:
                                    EmptyView()
                                case .error(let message):
                                    Text("리스트 업데이트 오류\n\(message)")
                                        .foregroundColor(.red)
                                } // switch
                            } // if
                            
                        } // LazyVGrid
                        .padding(.horizontal, 5)
                        .padding(.top, 1)
                        .padding(.bottom, 120)
                        
                    } // ScrollView
                } // VStack
                .padding()
                
                if loadingState {
                    ProgressView()
                }

            } // ZStack
            .onTapGesture {
                hideKeyboard()
            }
        } // NavigationView
    } // body
} // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookSearchViewModel(searchBooksResult: SearchBooksResult(numFound: 0, books: [])))
    }
}
