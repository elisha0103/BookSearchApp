//
//  BundleExtension.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import Foundation

extension Bundle {
    
    var searchAPILink: String {
        guard let file = self.path(forResource: "APILinkList", ofType: "plist") else {
            fatalError("APILinkList.plist가 없습니다.")
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("파일 형식 에러")
        }
        
        guard let key = resource["Search_API_Link"] as? String else {
            fatalError("APILinkList에 SearchAPILink를 설정해주세요.")
        }
        
        return key
    }
    
    var coversAPILink: String {
        guard let file = self.path(forResource: "APILinkList", ofType: "plist") else {
            fatalError("APILinkList.plist가 없습니다.")
        }

        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("파일 형식 에러")
        }

        guard let key = resource["Covers_API_Link"] as? String else {
            fatalError("APILinkList에 CoversAPILink를 설정해주세요.")
        }
        
        return key
    }
}
