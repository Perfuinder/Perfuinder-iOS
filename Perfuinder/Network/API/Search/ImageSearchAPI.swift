//
//  ImageSearchAPI.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/20/24.
//

import Foundation
import UIKit

/// 이미지 키워드 요청  API
class ImageSearchAPI: BaseAPI {
    static let shared = ImageSearchAPI()
    
    private override init() {
        super.init()
    }
    
    /// 키워드 받기
    func getKeyword(image: UIImage, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        AFManager.request(ImageSearchService.getKeyword(image)).responseData { (response) in
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
                completion(self.judgeData(by: statusCode, data, ImageSearchResponse.self))
                
            // 실패
            case .failure(let err):
                completion(.networkFail(err.localizedDescription))
            }
        }
    }
}
