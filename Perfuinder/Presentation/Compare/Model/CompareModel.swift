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
    let price: [PriceEntity]
    let seasonCode: SeasonCode
    let genderCode: GenderCode
    let keywords: [String]
    let perfumeDesc: String
    let mainNotes: [String]
    let topNoteDesc: String
    let middleNoteDesc: String
    let baseNoteDesc: String
}
