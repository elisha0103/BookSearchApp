//
//  MockURLSession.swift
//  BooksSearchSlowTests
//
//  Created by 진태영 on 2023/08/23.
//

import Foundation
import SwiftUI
@testable import BookSearchApp

class MockURLSession: URLSessionable {
    
    var makeRequestFail: Bool
    var sessionDataTask: MockURLSessionDataTask?
    
    init(makeRequestFail: Bool, sessionDataTask: MockURLSessionDataTask? = nil) {
        self.makeRequestFail = makeRequestFail
        self.sessionDataTask = sessionDataTask
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        print("Test dataTask")
        
        let urlString = "https://openlibrary.org/search.json?q=apple&page=1"
        
        let url = URL(string: urlString)!
        
        // 성공 callback
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        // 실패 callback
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 401,
                                              httpVersion: "2",
                                              headerFields: nil)

        let sessionDataTask: MockURLSessionDataTask = MockURLSessionDataTask()

        // sessionDataTask의 resumeDidCall에 makeRequestFail 값에 따라 달라지는 completionHandler를 할당함
        // resume() 이 호출되면 completionHandler()가 호출
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(NetworkMock.load(), successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }

    
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        // let urlString = "https://covers.openlibrary.org/b/id/10497758-M.jpg"
        
        //let url: URL = URL(string: urlString)!
        
        let image: Data = UIImage(systemName: "square")!.pngData()!

        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        // 실패 callback
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 401,
                                              httpVersion: "2",
                                              headerFields: nil)

        let sessionDataTask: MockURLSessionDataTask = MockURLSessionDataTask()

        // sessionDataTask의 resumeDidCall에 makeRequestFail 값에 따라 달라지는 completionHandler를 할당함
        // resume() 이 호출되면 completionHandler()가 호출
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(image, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask

    }

}
