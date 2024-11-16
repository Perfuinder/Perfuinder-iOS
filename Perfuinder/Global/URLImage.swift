//
//  URLImage.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import SwiftUI

/// 이미지 URL 문자열을 UIImage로 바꿔주는 뷰
struct URLImage: View {
    /// 이미지 URL
    var url: String
    
    var body: some View {
        // 비동기적으로 이미지 로드하기
        let ImageURL = URL(string: url)
        
        AsyncImage(url: ImageURL) { phase in
            // 이미지 로드를 성공한 경우
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            // 이미지 로드를 실패한 경우
            else if phase.error != nil {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                }
            }
            // 이미지 로드 중 애니메이션 띄우기
            else {
                ProgressView()
            }
        }
    }
}


#Preview {
    URLImage(url: "")
}
