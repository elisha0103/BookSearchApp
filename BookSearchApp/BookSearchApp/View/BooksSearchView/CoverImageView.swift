//
//  CoverImageView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

struct CoverImageView: View {
    @State var uIImage: UIImage?
    @State private var loadingState: Bool = false // ProgressView 출력용
    
    let coverCode: Int?
    
    var body: some View {
        ZStack {
            if let uIImage = uIImage {
                Image(uiImage: uIImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 180)
                    .shadow(radius: 6)
            } else {
                Image("NoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 180)
                    .shadow(radius: 6)
                    .onAppear {
                        Task {
                            loadingState.toggle()
                            if let cacheImage = try await WebService.fetchCoverImage(coverCode: coverCode, size: "M") {
                                uIImage = cacheImage
                            } else {
                                guard let noImage = UIImage(named: "NoImage.png") else {
                                    uIImage = UIImage(systemName: "book.closed")
                                    return
                                    
                                }
                                uIImage = noImage
                            }
                            loadingState.toggle()
                        }
                    }
            }
            if loadingState {
                ProgressView()
            }
        } // ZStack
    } // body
} // CoverImageView

struct CoverImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoverImageView(coverCode: 240727)
    }
}
