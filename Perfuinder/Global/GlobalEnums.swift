//
//  GlobalEnums.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

/// 계절코드
enum SeasonCode: Int {
    case spring
    case summer
    case fall
    case winter
    
    var text: String {
        switch self {
        case .spring: return "봄"
        case .summer: return "여름"
        case .fall: return "가을"
        case .winter: return "겨울"
        }
    }
    
    var image: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .fall: return "wind"
        case .winter: return "snowflake"
        }
    }
}
