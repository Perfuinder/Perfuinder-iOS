//
//  HomeAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/19/24.
//

import Foundation
import Alamofire

/// 홈화면 API
class HomeAPI: BaseAPI {
    static let shared = HomeAPI()
    
    private override init() {
        super.init()
    }
    
    /// 홈 조회
    func getHome(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(HomeService.getHome).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, HomeResponse.self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}
