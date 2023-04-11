//
//  BookSearchAppApp.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

@main
struct BookSearchAppApp: App {
    @StateObject var bookSearchViewModel: BookSearchViewModel = BookSearchViewModel(
        searchBooksResult: SearchBooksResult(numFound: 0, books: [])
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookSearchViewModel)
        }
    }
}
