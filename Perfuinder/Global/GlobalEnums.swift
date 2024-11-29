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

/// 용량별 가격
struct PriceEntity {
    let volume: Int
    let price: Int
}

/// 성별코드
enum GenderCode: Int {
    case male
    case female
    case unisex
    
    var componentText: String {
        switch self {
        case .male:
            "HIM"
        case .female:
            "HER"
        case .unisex:
            "UNI"
        }
    }
    
    var text: String {
        switch self {
        case .male:
            "남성"
        case .female:
            "여성"
        case .unisex:
            "중성"
        }
    }
}
