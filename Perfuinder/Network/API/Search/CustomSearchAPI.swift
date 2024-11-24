//
//  CustomSearchAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation

/// AI 탐색 향수 요청  API
class CustomSearchAPI: BaseAPI {
    static let shared = CustomSearchAPI()
    
    private override init() {
        super.init()
    }
    
    /// 검색정보 주고 추천향수 받기
    func getRecommend(request: CustomSearchRequest, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(CustomSearchService.getRecommend(request)).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, [CustomSearchResponse].self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}
