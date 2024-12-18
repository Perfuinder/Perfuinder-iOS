//
//  CompareService.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation
import Alamofire

/// 향수 비교하기 관련 Router
enum CompareService {
    case getComparePerfume(Int)
    case getCompareRecommendList(String)
}

extension CompareService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getComparePerfume:
            return .get
        case .getCompareRecommendList:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .getComparePerfume:
            return APIConstants.comparePerfumeURL
        case .getCompareRecommendList:
            return APIConstants.compareRecommendURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getComparePerfume(let id):
            return .path(String(id))
        case .getCompareRecommendList(let IDs):
            return .path(IDs)
        }
    }
}
