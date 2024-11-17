//
//  APIConstants.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation

/// HTTP 헤더
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}
