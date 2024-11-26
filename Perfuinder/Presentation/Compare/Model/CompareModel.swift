//
//  CompareModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

import Foundation

struct ComparePerfumeInfo {
    let perfumeID: Int
    let imageURL: String
    let brand: String
    let perfumeName: String
    let price: PriceDTO
    let seasonCode: SeasonCode
    let genderCode: GenderCode
    let keywords: [String]
    let perfumeDesc: String
    let topNoteDesc: String
    let middleNoteDesc: String
    let baseNoteDesc: String
}

struct PriceDTO: Codable {
    let volume: Int
    let price: Int
}

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
