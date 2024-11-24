//
//  FavoriteService.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import Foundation
import Alamofire

/// 향수 찜 관련 Router
enum FavoriteService {
    case favoriteToggle(Int)
}

extension FavoriteService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .favoriteToggle:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .favoriteToggle:
            return APIConstants.toggleFavorite
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .favoriteToggle(let id):
            return .path(String(id))
        }
    }
}
