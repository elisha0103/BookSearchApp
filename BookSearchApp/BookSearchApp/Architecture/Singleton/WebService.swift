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
        guard let coverCode = coverCode else {
            print("DEBUG: cover code no exist")
            completion(nil)
            return
            
        }
        
        let requestURL: String = "\(coversAPIURL)\(coverCode)-\(size).jpg"
        
        guard URL(string: requestURL) != nil else {
            print("URL String Error")
            return
        }
        
        CacheManager.imageLoadCache(urlString: requestURL) { image in
            guard let cachedImage = image else {
                completion(nil)
                return
            }
            completion(cachedImage)
        }
    }
    
    static func checkImageUpdate(imageUrl: String, completion: @escaping (Bool, UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        let etag = UserDefaults.standard.string(forKey: url.path) ?? ""
        
        var request = URLRequest(url: url)
        request.addValue(etag, forHTTPHeaderField: "If-None-Match")
        request.cachePolicy = .reloadIgnoringCacheData
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("checkImageUpdate occure error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("DEBUG: checkImageUpdate 함수 error")
                completion(false, nil) // 네트워크 오류로 ETag를 확인할 수 없어 캐시 이미지 사용
                return
            }
            print("DEBUG: response statuscode: \(response.statusCode)")
            switch response.statusCode {
            case (200...299):
                guard let data = data, let image = UIImage(data: data) else {
                    print("checkImageUpdate occure error: Data dosen't exist")
                    return
                }
                
                guard let etag = response.allHeaderFields["Etag"] as? String else {
                    completion(true, image)
                    return
                    
                }
                
                // 서버로 로드된 파일을 기기 메모리, disk 영역에 저장
                CacheManager.imageSetMemory(image: image, urlString: imageUrl)
                CacheManager.imageSetDisk(image: image, urlString: imageUrl, etag: etag)
                
                completion(true, image)
            case 304:
                completion(false, nil)
            default:
                print("DEBUG: checkImageUpdate etag 없음")
                completion(false, nil)
                
            }
        }
        .resume()
    }
    
}
