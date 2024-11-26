//
//  CompareViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

import Foundation

class CompareViewModel: ObservableObject {
    /// 첫번째 column 향수
    @Published var first: ComparePerfumeInfo?
    
    /// 두번째 column 향수
    @Published var second: ComparePerfumeInfo?
    
    /// 어떤 비교정보 보여줘야할지 선택하는 비교 타입
    /// - 추천향수 중 비교
    /// - 찜한향수 중 비교
    let compareType: CompareType
    
    init(first: ComparePerfumeInfo? = nil, second: ComparePerfumeInfo? = nil, compareType: CompareType) {
        self.first = first
        self.second = second
        self.compareType = compareType
    }
}


// 어느 화면에서 불러왔는지 체크할 수 있게
enum CompareType {
    case recommend
    case like
}
