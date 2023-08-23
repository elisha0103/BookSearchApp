//
//  NetworkMock.swift
//  BooksSearchSlowTests
//
//  Created by 진태영 on 2023/08/23.
//

import Foundation

struct NetworkMock {
    
    static func load() -> Data? {
        // 1. 불러올 파일 이름
        let fileNm: String = "JSONMockData"
        // 2. 불러올 파일의 확장자명
        let extensionType = "json"
        
        // 3. 파일 위치
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else {
            print("파일 위치 없음")
            return nil }
        
        
        do {
            // 4. 해당 위치의 파일을 Data로 초기화하기
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            // 5. 잘못된 위치나 불가능한 파일 처리
            print("json load fail")
            return nil
        }
    }

}
