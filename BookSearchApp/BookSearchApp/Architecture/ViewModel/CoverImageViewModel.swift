//
//  CoverImageViewModel.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/19.
//

import Foundation
import SwiftUI

final class CoverImageViewModel: ObservableObject {
    @Published var uIImage: UIImage?
    @Published var loadingState: Bool = false // ProgressView 출력용
    let coverCode: Int?
    
    init(uIImage: UIImage?, coverCode: Int?) {
        self.uIImage = uIImage
        self.coverCode = coverCode
    }
}
