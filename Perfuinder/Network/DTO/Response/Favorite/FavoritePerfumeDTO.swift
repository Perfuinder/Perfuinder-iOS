//
//  FavoritePerfumeDTO.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import Foundation

/// 찜한향수 정보 조회용 DTO
struct FavoritePerfumeDTO: Codable {
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let keywords: [String]
    let perfumeDesc: String
}

extension FavoritePerfumeDTO {
    func toCompareSheetEntity() -> CompareSheetModel {
        return CompareSheetModel(perfumeID: self.perfumeId,
                                 brand: self.brand,
                                 perfumeName: self.perfumeName,
                                 imageUrl: self.imageUrl,
                                 tokens: self.keywords,
                                 perfumeDesc: self.perfumeDesc)
    }
    
    func toMyPageEntity() -> MyPagePerfumeModel {
        return MyPagePerfumeModel(isFavorite: true,
                           perfumeId: self.perfumeId,
                           brand: self.brand,
                           perfumeName: self.perfumeName,
                           imageUrl: self.imageUrl,
                           keywords: self.keywords,
                           perfumeDesc: self.perfumeDesc)
    }
}
