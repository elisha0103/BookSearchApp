//
//  URLSessionable.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/08/23.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol URLSessionable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol
    
    func dataTask(with url: URL,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionable {
    // Network Test를 위한 URLSessionDataTaskProtocol 정의로 인해 기존 URLSession에 있는 dataTask 인스턴스 메소드가 아닌 새로운 메소드 정의하여 사용
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    func dataTask(with url: URL,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
