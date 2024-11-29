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
    case getFavoriteList
    case favoriteToggle(Int)
}

extension FavoriteService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getFavoriteList:
            return .get
        case .favoriteToggle:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .getFavoriteList:
            return APIConstants.favoriteInfoURL
        case .favoriteToggle:
            return APIConstants.toggleFavorite
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getFavoriteList:
            return .requestPlain
        case .favoriteToggle(let id):
            return .path(String(id))
        }
    }
}
