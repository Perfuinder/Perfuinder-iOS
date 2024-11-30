//
//  CompareAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation
import Alamofire

/// 향수 비교 관련 API
class CompareAPI: BaseAPI {
    static let shared = CompareAPI()
    
    private override init() {
        super.init()
    }
    
    /// 검색정보 주고 추천향수 받기
    func getComparePerfume(id: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(CompareService.getComparePerfume(id)).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, [ComparePerfumeResponse].self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}

