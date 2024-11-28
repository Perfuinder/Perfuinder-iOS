//
//  CompareModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

import Foundation

/// 비교하기 화면에서 보여줄 향수 하나의 정보
struct ComparePerfumeInfo {
    let perfumeID: Int
    let imageURL: String
    let brand: String
    let perfumeName: String
    let price: [PriceDTO]
    let seasonCode: SeasonCode
    let genderCode: GenderCode
    let keywords: [String]
    let perfumeDesc: String
    let mainNotes: [String]
    let topNoteDesc: String
    let middleNoteDesc: String
    let baseNoteDesc: String
}

/// 용량별 가격
struct PriceDTO: Codable {
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
