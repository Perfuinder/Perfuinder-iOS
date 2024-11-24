//
//  CustomSearchResponse.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation

/// AI 탐색결과
struct CustomSearchResponse: Codable {
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let mainNotes: [String]
    let perfumeDesc: String
    var favorite: Bool
}
