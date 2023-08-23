//
//  BooksSearchSlowTests.swift
//  BooksSearchSlowTests
//
//  Created by 진태영 on 2023/04/13.
//

import XCTest
@testable import BookSearchApp

final class BooksSearchSlowTests: XCTestCase {
    // MARK: - Properties
    var sut: URLSessionable?
    
    // MARK: - Methods
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockURLSession(makeRequestFail: false)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func testFetchSearchBooksResultWhenSuccess() {
        sut = MockURLSession(makeRequestFail: false)

        // async테스트를 위해서 XCTestExpectation 사용
        let expectation = XCTestExpectation()

        let searchURLString = "https://openlibrary.org/search.json?q="
        let guess = "thr lord of rings"
        
        let searchStringWithOutSpace = guess
            .trimmingCharacters(in: [" "]) // 문자열 양 끝단 공백 제거
            .replacingOccurrences(of: " ", with: "+") // 문자열 사이 공백 "+"로 치환
        
        guard !searchStringWithOutSpace.isEmpty else { return }
        
        let requestURLString = "\(searchURLString)\(searchStringWithOutSpace)&page=1"
        
        let searchURL = URL(string: requestURLString)!
        
        guard let sampleData: Data = NetworkMock.load() else {
            print(" sampleData가 없습니다.")
            return
        }
        
        let responseMock = try? JSONDecoder().decode(SearchBooksResult.self, from: sampleData)
        
        sut?.dataTask(with: searchURL, completionHandler: { data, response, error in
            if let data = data {
                print("****Test****\n테스트 성공\n********")
                let result = try? JSONDecoder().decode(SearchBooksResult.self, from: data)
                let searchBooksResult = SearchBooksResultPModel.converTo(result!)
                XCTAssertEqual(responseMock?.books.first?.title, searchBooksResult.books.first?.title)
            } else {
                XCTFail(error?.localizedDescription ?? "")
            }
            print("urlRespnse: \(response.debugDescription)")
            expectation.fulfill()
        })
        .resume()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchSearchBooksResultWhenFail() {
        sut = MockURLSession(makeRequestFail: true)
        
        let expectation = XCTestExpectation()
        
        let searchURLString = "https://openlibrary.org/search.json?q="
        let guess = "thr lord of rings"
        
        let searchStringWithOutSpace = guess
            .trimmingCharacters(in: [" "]) // 문자열 양 끝단 공백 제거
            .replacingOccurrences(of: " ", with: "+") // 문자열 사이 공백 "+"로 치환
        
        guard !searchStringWithOutSpace.isEmpty else { return }
        
        let requestURLString = "\(searchURLString)\(searchStringWithOutSpace)&page=1"
        
        let searchURL = URL(string: requestURLString)!

        sut?.dataTask(with: searchURL, completionHandler: { data, response, error in
            if let data = data {
                XCTFail()
            } else {
                print("****Test****\nError: \(String(describing: error?.localizedDescription))\n********")
            }
            expectation.fulfill()
        })
        .resume()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchCoverImageWhenSuccess() {
        sut = MockURLSession(makeRequestFail: false)
        let expectation = XCTestExpectation()

        let coversURLString = "https://covers.openlibrary.org/b/id/"
        let coverCode: Int = 9255566
        let size: String = "M"

        let requestURL: String = "\(coversURLString)\(coverCode)-\(size).jpg" // API Request URL String
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return
        }
        
        sut?.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                print("request 성공: \(data.description)")
            } else {
                XCTFail(error?.localizedDescription ?? "")
            }
            print("urlRespnse: \(response.debugDescription)")
            expectation.fulfill()
        })
        .resume()

        wait(for: [expectation], timeout: 2.0)
        
    }
    
    func testFetchCoverImageWhenFail() {
        sut = MockURLSession(makeRequestFail: true)
        let expectation = XCTestExpectation()
        
        let coversURLString = "https://covers.openlibrary.org/b/id/"
        let coverCode: Int = 9255566
        let size: String = "M"

        let requestURL: String = "\(coversURLString)\(coverCode)-\(size).jpg" // API Request URL String
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return
        }
        
        sut?.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                XCTFail()
            } else {
                print("request 실패, 테스트 성공: \(String(describing: error?.localizedDescription))")
            }
            expectation.fulfill()
        })
        .resume()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}
