//
//  CompareSheetViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation

/// 비교하기 sheet용 뷰모델
class CompareSheetViewModel: ObservableObject {
    /// 추천 또는 찜 중 어느 종류 리스트 불러와야되는지 확인용
    let compareType: CompareType
    
    /// 비교선택을 위해 보여줄 리스트용 향수 데이터
    @Published var data: [CompareSheetModel]?
    
    /// 추천향수 비교리스트 조회용 생성자
    init(idList: [Int]) {
        self.compareType = .recommend
        
        // data 입력하기
        if compareType == .recommend {
            getRecommendPerfumeList(idList: idList) { success in
                if !success {
                    // 실패 코드 처리
                }
            }
        }
    }
    
    func getPerfumeIDString(of idList: [Int]) -> String {
        let perfumeIDs = idList.map { String($0) }
        return perfumeIDs.joined(separator: ",")
    }
    
    /// 추천향수 id 리스트 넘겨서 id에 해당하는 리스트 컴포넌트용 정보 받기
    func getRecommendPerfumeList(idList: [Int], completion: @escaping (Bool) -> Void) {
        
        let idString = getPerfumeIDString(of: idList)
        
        CompareSheetAPI.shared.getRecommendPerfumeInfo(idList: idString) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? [CompareRecommendPerfumeDTO] {
                    self.data = data.map {
                        $0.toEntity()
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
