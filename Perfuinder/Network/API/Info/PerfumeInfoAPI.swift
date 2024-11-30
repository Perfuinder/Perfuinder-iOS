//
//  InfoAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 12/1/24.
//

import Foundation
import Alamofire

/// 향수 상세 정보 조회 API
class PerfumeInfoAPI: BaseAPI {
    static let shared = PerfumeInfoAPI()
    
    private override init() {
        super.init()
    }
    
    /// id에 해당하는 향수의 상세정보 받기
    func getPerfumeInfo(id: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(PerfumeInfoService.getPerfumeInfo(id)).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, PerfumeInfoResponse.self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}
