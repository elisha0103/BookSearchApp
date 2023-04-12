//
//  CoverImageView.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/12.
//

import SwiftUI

struct CoverImageView: View {
    @State var data: Data?
    @State private var loadingState: Bool = false // ProgressView 출력용
    private let coversAPIURL = Bundle.main.coversAPILink // APILinkList.plist Covers_API_Link 값
    let coverCode: Int?
    
    var body: some View {
        ZStack {
            if let data = data, let uIImage = UIImage(data: data) {
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
                            try await fetchImageData(coverCode: coverCode, size: "M")
                            loadingState.toggle()
                        }
                    }
            }
            
            if loadingState {
                ProgressView()
            }
        } // ZStack
    } // body
    
    // MARK: - Cover 이미지 fetch 함수
    private func fetchImageData(coverCode: Int?, size: String) async throws {
        guard let coverCode = self.coverCode else { return }
        
        let resultURL: String = "\(coversAPIURL)\(coverCode)-\(size).jpg"
        print(resultURL)
        guard let url = URL(string: resultURL) else { return }
        
        print("CoverImageView fetch Image Data")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        self.data = data
        
        return
    } // fetchImageData
} // CoverImageView

struct CoverImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoverImageView(coverCode: 240727)
    }
}

/*
 .resizable()
 .aspectRatio(contentMode: .fill)
 .frame(width: 100, height: 180)
 .shadow(radius: 6)
 
 */
