//
//  MyPageModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import Foundation

/// 마이페이지용 향수 정보 모델
struct MyPagePerfumeModel {
    var isFavorite: Bool
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let keywords: [String]
    let perfumeDesc: String
}
