//
//  ImageSearchService.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/20/24.
//

import Foundation
import Alamofire
import UIKit

/// 이미지 키워드 요청 Router
enum ImageSearchService {
    case getKeyword(UIImage)
}

extension ImageSearchService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getKeyword:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .getKeyword:
            return APIConstants.imageKeywordURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getKeyword(let image):
            return .uploadImage(image)
        }
    }
}
