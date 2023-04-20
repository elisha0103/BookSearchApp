//
//  CoverImageView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

struct CoverImageView: View {
    @ObservedObject var coverImageViewModel: CoverImageViewModel
    
    var body: some View {
        ZStack {
            if let uIImage = coverImageViewModel.uIImage {
                Image(uiImage: uIImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
                            if !coverImageViewModel.loadingState {
                                coverImageViewModel.loadingState = true
                                if let cacheImage = try await WebService.fetchCoverImage(coverCode: coverImageViewModel.coverCode, size: "M") {
                                    coverImageViewModel.uIImage = cacheImage
                                } else {
                                    guard let noImage = UIImage(named: "NoImage.png") else {
                                        coverImageViewModel.uIImage = UIImage(systemName: "book.closed")
                                        return
                                        
                                    }
                                    coverImageViewModel.uIImage = noImage
                                }
                                coverImageViewModel.loadingState = false
                            }
                        }
                    }
            }
            if coverImageViewModel.loadingState {
                ProgressView()
            }
        }
    }
} 

// struct CoverImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoverImageView(coverImageViewModel: cover)
//    }
// }
