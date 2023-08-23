//
//  WebService.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

final class WebService {
    static private let session: URLSessionable = URLSession.shared
    static private let searchAPIURL = "https://openlibrary.org/search.json?q=" // Search_API
    static private let coversAPIURL = "https://covers.openlibrary.org/b/id/" // Covers_API 값
    
    // MARK: - 책 fetch 함수
    static func fetchBooksData(keyWords: String, page: Int,
                               completion: @escaping (SearchBooksResultPModel?, Error?) -> Void) {
        let requestURL: String = "\(searchAPIURL)\(keyWords)&page=\(page)"
        
        print("요청 링크: \(requestURL)")
        
        guard let url = URL(string: requestURL) else {
            print("요청 URL이 잘못됐습니다.")
            return
        }
        
        session.dataTask(with: url) { data, _, error in
            do {
                guard let data = data else { return }
                
                let searchResult = try JSONDecoder().decode(SearchBooksResult.self, from: data)
                completion(SearchBooksResultPModel.converTo(searchResult), error)
            } catch {
                print("request 실패")
            }
        }
        .resume()
        
    }
    
    // MARK: - Cover 이미지 fetch 함수
    static func fetchCoverImage(coverCode: Int?, size: String,
                                completion: @escaping (UIImage?) -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        guard let coverCode = coverCode else { return }
        
        let requestURL: String = "\(coversAPIURL)\(coverCode)-\(size).jpg"
        
        guard let url = URL(string: requestURL) else {
            print("URL String Error")
            return
        }
        
        if let cachedImage = CacheManager.imageLoadCache(urlString: requestURL) { // 기기 메모리 혹은 디스크로부터 이미지 호출
            print("이미지 캐시 반환")
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("캐시 로드 시간: \(diff)")
            completion(cachedImage)
        } else { // 기기에 캐시 파일 없으면 서버로부터 load
            
            session.dataTask(with: url) { data, _, error in
                guard error == nil else {
                    print("Error: Fetch Cover Image Error \(String(describing: error?.localizedDescription))")
                    return
                }
                guard let data = data else { return }
                
                guard let image = UIImage(data: data) else {
                    print("Error: UIImage's Data isn't exsist")
                    return
                }
                
                let diff = CFAbsoluteTimeGetCurrent() - start
                print("서버 로드 시간: \(diff)")
                // 서버로 로드된 파일을 기기 메모리, disk 영역에 저장
                CacheManager.imageSetDisk(image: image, urlString: requestURL)
                CacheManager.imageSetMemory(image: image, urlString: requestURL)
                
                print("api 서버 이미지 반환")
                
                completion(image)
            }
            .resume()
        }
        
    }
}
