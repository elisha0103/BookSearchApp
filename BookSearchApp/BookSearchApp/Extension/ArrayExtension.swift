//
//  ArrayExtension.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/13.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
