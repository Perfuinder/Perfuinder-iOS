//
//  CompareSheetAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation
import Alamofire

/// 비교용 향수 선택을 위한 정보 요청 API
class CompareSheetAPI: BaseAPI {
    static let shared = CompareSheetAPI()
    
    private override init() {
        super.init()
    }
    
    /// 검색정보 주고 추천향수 받기
    func getRecommendPerfumeInfo(idList: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(CompareService.getCompareRecommendList(idList)).responseData { (response) in
            switch response.result {
            // 성공
            case .success:
                guard let statusCode = response.response?.statusCode
                else {
                    return
                }
                
                guard let data = response.data
                else {
                    return
                }
                completion(self.judgeData(by: statusCode, data, [CompareRecommendPerfumeDTO].self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
    
    // TODO: 찜한 향수들 리스트용 정보 요청하기
}

