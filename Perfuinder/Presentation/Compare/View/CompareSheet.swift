//
//  CompareSheet.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import SwiftUI

/// 향수 비교에서 향수 선택/변경할 때 보여줄 Sheet용 View
struct CompareSheet: View {
    // MARK: - Properties
    /// 현재 뷰를 sheet로 띄웠을 때 dissmiss시키기 위한 변수
    @Binding var showCompareSheet: Bool
    
    let compareType: CompareType
    
    /// 선택된 표시해줄 향수 ID
    /// - 바꿀 향수가 아니라 비교하기 페이지에서 변경할 때 참고하기 위한 상대편 향수
    let toComparePerfumeID: Int?
    
    /// 이 뷰에서 선택해서 비교하기로 넘길 향수의 ID
    @Binding var currentPerfumeID: Int?
    
//    /// parent view에서 전달받을 추천향수 5종 데이터
//    let perfumeData: [Int]?
    
    @StateObject var vm: CompareSheetViewModel
    
    // MARK: - Initializers
    /// 추천향수주
    init(showCompareSheet: Binding<Bool>,
         compareType: CompareType,
         toComparePerfumeID: Int? = nil,
         currentPerfumeID: Binding<Int?>,
         perfumeData: [Int]? = nil) {
        
        _showCompareSheet = showCompareSheet
        self.compareType = compareType
        self.toComparePerfumeID = toComparePerfumeID
        _currentPerfumeID = currentPerfumeID
        _vm = StateObject(wrappedValue: CompareSheetViewModel(idList: perfumeData ?? []))
    }

    
    
    // MARK: - View
    var body: some View {      
        Text(String(currentPerfumeID ?? 0))
    }
}


// MARK: - Functions
extension CompareSheet {
    
}
