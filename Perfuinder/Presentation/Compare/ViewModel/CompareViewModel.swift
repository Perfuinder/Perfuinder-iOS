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
            getComparePerfume(isFirst: true, id: ID1) { success in
                // 실패처리
            }
        }
        
        if let ID2 = secondID {
            // TODO: ID 활용해서 향수정보 불러오기
            getComparePerfume(isFirst: false, id: ID2) { success in
                // 실패처리
            }
        }
    }
    
    /// 요청한 ID에 해당하는 향수의 비교하기 정보 받아오기
    /// - isFirst: 왼쪽 향수인지 오른쪽 향수인지 여기서 받아서 데이터에 바로 입력해주기 위한 아규먼트
    func getComparePerfume(isFirst: Bool, id: Int, completion: @escaping (Bool) -> Void) {
        CompareAPI.shared.getComparePerfume(id: id) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? [ComparePerfumeDTO], let responsePerfumeData = data.first {
                    // 1열 향수 정보 요청이었으면 첫번째 향수로 데이터 입력해주기
                    if isFirst {
                        self.first = responsePerfumeData.toEntity()
                    }
                    // 2열 향수 정보 요청이었으면 두번째 향수로,
                    else {
                        self.second = responsePerfumeData.toEntity()
                    }
                }
                completion(true)
                
            case .requestErr(let message):
                print("Request Err: \(message)")
                completion(false)
            case .pathErr:
                print("Path Err")
                completion(false)
            case .serverErr(let message):
                print("Server Err: \(message)")
                completion(false)
            case .networkFail(let message):
                print("Network Err: \(message)")
                completion(false)
            case .unknown(let error):
                print("Unknown Err: \(error)")
                completion(false)
            }
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
