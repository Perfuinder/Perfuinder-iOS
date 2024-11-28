//
//  CompareViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

import Foundation

/// 비교하기 뷰모델
class CompareViewModel: ObservableObject {
    /// 어떤 비교정보 보여줘야할지 선택하는 비교 타입
    /// - 추천향수 중 비교
    /// - 찜한향수 중 비교
    @Published var compareType: CompareType
    
    /// 첫번째 column 향수
    @Published var first: ComparePerfumeInfo?
    @Published var firstID: Int?
    
    /// 두번째 column 향수
    @Published var second: ComparePerfumeInfo?
    @Published var secondID: Int?
    
    
    /// 추천향수 중 비교일 때는 추천향수들 ID 배열으로 받아와야함
    /// - compareType이 .recommend일 때만 있는 정보
    /// - 근데 compareType이 .recommend일 때는 꼭 있어야 함..
    @Published var recommendedPerfumeIDs: [Int]?
    
    // 생성자
    init(firstID: Int? = nil,
         secondID: Int? = nil,
         compareType: CompareType,
         recommendedPerfumeIDs: [Int]? = nil
    ) {
        self.firstID = firstID
        self.secondID = secondID
        self.compareType = compareType
        self.recommendedPerfumeIDs = recommendedPerfumeIDs
        
        // 호출될 때 ID가 있다면 그 ID대로 호출하기
        if let ID1 = firstID {
            // TODO: ID 활용해서 향수정보 불러오기
        }
        
        if let ID2 = secondID {
            // TODO: ID 활용해서 향수정보 불러오기
        }
    }
}


// 어느 화면에서 불러왔는지 체크할 수 있게
enum CompareType {
    /// 추천향수중에서 비교
    case recommend
    /// 찜한 향수 중에서 비교
    case like
}
