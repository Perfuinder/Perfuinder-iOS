//
//  CompareSheetModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/29/24.
//

import Foundation

/// 비교하기 Sheet에서 리스트 셀 컴포넌트 하나에서 보여줄 정보들
struct CompareSheetModel {
    let perfumeID: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
    let tokens: [String]
    let perfumeDesc: String
}
