//
//  Compare_Recommend.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import SwiftUI

/// 키워드별 향수 추천에서 '다른 향수와 비교하기' 버튼 눌렀을 때 보여줄 Sheet용 View
struct Compare_Recommend: View {
    // MARK: - Properties
    /// 현재 뷰를 sheet로 띄웠을 때 dissmiss시키기 위한 변수
    @Binding var showCompareSheet: Bool
    
    /// 향수 비교하기 눌렀을 때의 기본선택된 향수(선택된 표시해줄 향수 ID)
    let currentPerfumeID: Int?
    
    /// 이 뷰에서 선택해서 비교하기로 넘길 향수의 ID
    @Binding var toComparePerfumeID: Int?
    
    /// parent view에서 전달받을 추천향수 5종 데이터
    let perfumeData: [Int]
    
    
    // MARK: - View
    var body: some View {      
        Text(String(perfumeData.count))
    }
}

//#Preview {
//    Compare_Recommend()
//}
