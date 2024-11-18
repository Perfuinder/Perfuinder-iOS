//
//  HomeService.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/19/24.
//

import Foundation
import Alamofire

/// 홈화면 Router
enum HomeService {
    // 홈화면 조회
    case getHome
}

extension HomeService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getHome:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .getHome:
            return APIConstants.homeURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getHome:
            return .requestPlain
        }
    }
}
