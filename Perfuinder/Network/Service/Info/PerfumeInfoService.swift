//
//  PerfumeInfoService.swift
//  Perfuinder
//
//  Created by 석민솔 on 12/1/24.
//

import Foundation
import Alamofire

/// 향수 상세 정보 조회 Router
enum PerfumeInfoService {
    case getPerfumeInfo(Int)
}

extension PerfumeInfoService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getPerfumeInfo:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .getPerfumeInfo:
            return APIConstants.perfumeInfoURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getPerfumeInfo(let id):
            return .path(String(id))
        }
    }
}
