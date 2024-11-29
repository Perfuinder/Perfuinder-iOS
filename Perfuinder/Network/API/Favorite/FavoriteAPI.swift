//
//  FavoriteAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import Foundation
import Alamofire

/// 향수 찜 관련 API
class FavoriteAPI: BaseAPI {
    static let shared = FavoriteAPI()
    
    private override init() {
        super.init()
    }
    
    /// 검색정보 주고 추천향수 받기
    func favoriteToggle(id: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(FavoriteService.favoriteToggle(id)).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, Bool.self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
    
    /// 찜한 향수 정보 조회하기
    func getFavoriteInfo(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(FavoriteService.getFavoriteList).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, [FavoritePerfumeDTO].self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}
