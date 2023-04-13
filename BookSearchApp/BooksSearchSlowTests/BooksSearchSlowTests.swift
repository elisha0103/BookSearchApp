//
//  BooksSearchSlowTests.swift
//  BooksSearchSlowTests
//
//  Created by 진태영 on 2023/04/13.
//

import XCTest
@testable import BookSearchApp

final class BooksSearchSlowTests: XCTestCase {
    var sut: URLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    
    // MARK: - 도서 검색 테스트
    func testFetchBooksDataWithSearchString() async throws {
        let searchURLString = "https://openlibrary.org/search.json?q="
        let guess = "thr lord of rings"
        
        let searchStringWithOutSpace = guess
            .trimmingCharacters(in: [" "]) // 문자열 양 끝단 공백 제거
            .replacingOccurrences(of: " ", with: "+") // 문자열 사이 공백 "+"로 치환
        
        guard !searchStringWithOutSpace.isEmpty else { return }
        
        let requestURLString = "\(searchURLString)\(searchStringWithOutSpace)&page=1"
        
        let searchURL = URL(string: requestURLString)!
        
        let promise = expectation(description: "데이터가 성공적으로 호출됐습니다.")
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: searchURL)
            if !data.isEmpty {
                promise.fulfill()
            } else {
                print("데이터 없음")
            }
            print("urlRespnse: \(urlResponse)")
            
        } catch let error as NSError {
            XCTFail("Error: \(error.localizedDescription)")
        }
        
        await fulfillment(of: [promise], timeout: 5)
    }
    
    // MARK: - 이미지 검색 테스트
    func testFetchCoverImageWithCoverI() async throws {
        let coversURLString = "https://covers.openlibrary.org/b/id/"
        let coverCode: Int = 9255566
        let size: String = "M"
        
        let requestURL: String = "\(coversURLString)\(coverCode)-\(size).jpg" // API Request URL String
        let promise = expectation(description: "이미지가 성공적으로 호출됐습니다.")
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        if !data.isEmpty {
            print("fetchover")
            promise.fulfill()
        } else {
            print("이미지 없음")
        }
        
        print("urlRespnse: \(urlResponse.debugDescription)")

        await fulfillment(of: [promise], timeout: 5)
        
    }
    
}
