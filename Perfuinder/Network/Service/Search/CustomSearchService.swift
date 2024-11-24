//
//  CustomSearchService.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation
import Alamofire

/// AI 탐색 향수 요청 Router
enum CustomSearchService {
    case getRecommend(CustomSearchRequest)
}

extension CustomSearchService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getRecommend:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .getRecommend:
            return APIConstants.geminiSearchURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getRecommend(let request):
            return .requestBody(request)
        }
    }
}
