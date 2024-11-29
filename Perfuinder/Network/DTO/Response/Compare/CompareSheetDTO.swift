//
//  CompareSheetDTO.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation

// MARK: CompareRecommendPerfumeDTO
/// 비교하기 향수 추천 조회용 DTO
struct CompareRecommendPerfumeDTO: Codable {
    let perfumeID: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let mainNotes: [String]
    let perfumeDesc: String
}

extension CompareRecommendPerfumeDTO {
    func toEntity() -> CompareSheetModel {
        return CompareSheetModel(perfumeID: self.perfumeID,
                                 brand: self.brand,
                                 perfumeName: self.perfumeName,
                                 imageUrl: self.imageUrl,
                                 tokens: self.mainNotes,
                                 perfumeDesc: self.perfumeDesc)
    }
}
