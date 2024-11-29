//
//  CompareSheetListCell.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import SwiftUI

/// 향수 고르기 Sheet 향수 하나용 Sheet
struct CompareSheetListCell: View {
    /// 정보 보여줄 향수 객체
    let perfume: CompareSheetModel
    
    /// 선택된 향수로 disable하기 위한 용도
    /// - 비교할 다른 향수의 list cell일 경우에 활성화
    let isDisabled: Bool
    
    /// 현재 화면에서 고른 향수일 때
    let isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 25) {
            URLImage(url: perfume.imageUrl)
                .frame(width: 120, height: 160) // 이미지 크기
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 60, height: 140) // UI에서 취급되는 크기
            
            VStack(alignment: .leading, spacing: 5) {
                if isDisabled || isSelected {
                    HStack(alignment: .center, spacing: 3) {
                        Image(systemName: "checkmark")
                            .font(.caption2)
                            .foregroundStyle(Color.secondary)
                        
                        Text("선택됨")
                            .font(.caption2)
                            .foregroundStyle(Color.secondary)
                    }
                    .padding(.bottom, 5)
                }
                
                
                Text(perfume.brand)
                    .font(.subheadline)
                    .foregroundStyle(Color.black)
                
                Text(perfume.perfumeName)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.black)
                
                Text(perfume.perfumeDesc)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.black)
                
                WrapLayout {
                    ForEach(perfume.tokens, id: \.self) { text in
                        PureToken(text: text)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.leading, perfume.brand == "FORMENT" ? 25 : 0)
            .frame(maxWidth: .infinity)
            
        }
        .padding(.vertical, 15)
        .background(Color.white)
        .opacity(isDisabled ? 0.5 : 1)  // 변경 불가능한 향수 표시
    }
}
