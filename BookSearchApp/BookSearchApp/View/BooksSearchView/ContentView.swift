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
    @State var retainString: String = "" // 검색 후 검색 키워드 임시저장하는 변수
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    // MARK: - 도서 검색 View
                    HStack {
                        TextField("도서 검색", text: $searchString, onCommit: {
                            self.retainString = searchString
                            bookSearchViewModel.resetViewModelData()
                            
                            if loadingState == false {
                                Task {
                                    loadingState = true
                                    await bookSearchViewModel.fetchBooksData(searchString: retainString)
                                    loadingState = false
                                }
                            }
                            
                        })
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.bottom, 10)
                        .cornerRadius(10)
                        .modifier(TextFieldClearButton(fieldText: $searchString))
                        Spacer()
                        
                        Button {
                            self.retainString = searchString
                            bookSearchViewModel.resetViewModelData()
                            
                                Task {
                                    loadingState = true
                                    await bookSearchViewModel.fetchBooksData(searchString: retainString)
                                    loadingState = false
                                }

                        } label: {
                            Text("검색")
                                .foregroundColor(.black)
                                .bold()
                        }
                        
                    }
                    .frame(height: 15)
                    
                    // MARK: - 도서 검색 결과 View
                    Text("검색 결과: \(bookSearchViewModel.searchBooksResultPModel.numFound)개")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach($bookSearchViewModel.searchBooksResultPModel.books, id: \.self) { $book in
                                NavigationLink {
                                    BookDetailView(book: $book)
                                } label: {
                                    BookCellView(
                                        bookTitle: $book.title,
                                        presentAuthors: book.presentAuthors,
                                        presentRatingAverage: book.presentRatingAverage,
                                        coverID: $book.coverI
                                    )
                                }
                                .accentColor(.black)
                            }
                            
                            // MARK: - Pagenation
                            if !loadingState { // 검색 중에는 페이지네이션 동작 제한
                                switch bookSearchViewModel.loadingBooksDataState {
                                case .done:
                                    Color.clear
                                        .onAppear {
                                            Task {
                                                await bookSearchViewModel.fetchBooksData(searchString: retainString)
                                            }
                                        }
                                case .isLoading:
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .progressViewStyle(.circular)
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .progressViewStyle(.circular)
                                case .loadedAll:
                                    EmptyView()
                                case .error(let message):
                                    Text("리스트 업데이트 오류\n\(message)")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }
                        .padding(.horizontal, 5)
                        .padding(.top, 1)
                        .padding(.bottom, 120)
                        
                    }
                }
                .padding()
                
                if loadingState {
                    ProgressView()
                }
                
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookSearchViewModel(
                searchBooksResultPModel: SearchBooksResultPModel(numFound: 0, books: [])
            ))
    }
}
