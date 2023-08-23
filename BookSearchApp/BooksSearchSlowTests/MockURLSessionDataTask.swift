//
//  MockURLSessionDataTask.swift
//  BooksSearchSlowTests
//
//  Created by 진태영 on 2023/08/23.
//

import Foundation
@testable import BookSearchApp

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var resumeDidCall: (() -> ())?
        
    init(resumeDidCall: ( () -> Void)? = nil) {
        self.resumeDidCall = resumeDidCall
    }
    
    func resume() {
        resumeDidCall?()
    }
}
