//
//  CustomSearchRequest.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/21/24.
//

import Foundation

/// AI 탐색 검색하기 위한 정보
struct CustomSearchRequest: Encodable {
    var keywords: String? = nil
    var seasonCode: Int? = nil
    var priceRangeCode: Int = 0
    var customPriceRangeMin: Int? = nil
    var customPriceRangeMax: Int? = nil
}
