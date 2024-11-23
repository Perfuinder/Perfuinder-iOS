//
//  RecommendViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation

class RecommendViewModel: ObservableObject {
    let searchBody: CustomSearchRequest
    @Published var data: [CustomSearchResponse]?
    
    init(searchBody: CustomSearchRequest) {
        self.searchBody = searchBody
        requestRecommend(request: searchBody) { success in
            if !success {
                // 실패 결과 컨트롤
            }
        }
    }
    
    func requestRecommend(request: CustomSearchRequest, completion: @escaping (Bool) -> Void) {
        CustomSearchAPI.shared.getRecommend(request: request) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? [CustomSearchResponse] {
                    self.data = data
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

/*
 func requestImageKeywords(image: UIImage, completion: @escaping (Bool) -> Void) {
     ImageSearchAPI.shared.getKeyword(image: image) { response in
         switch response {
         case .success(let data):
             // 성공 시, 서버에서 받은 키워드 입력
             if let data = data as? ImageSearchResponse {
                 self.imageKeywords = data.keywords
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
 */
