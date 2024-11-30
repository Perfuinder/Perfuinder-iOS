//
//  CompareSheetDTO.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation

// MARK: CompareRecommendPerfumeResponse
/// 비교하기 향수 추천 조회용 DTO
struct CompareRecommendPerfumeResponse: Codable {
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let mainNotes: [String]
    let perfumeDesc: String
}

extension CompareRecommendPerfumeResponse {
    func toEntity() -> CompareSheetModel {
        return CompareSheetModel(perfumeID: self.perfumeId,
                                 brand: self.brand,
                                 perfumeName: self.perfumeName,
                                 imageUrl: self.imageUrl,
                                 tokens: self.mainNotes,
                                 perfumeDesc: self.perfumeDesc)
    }
}
