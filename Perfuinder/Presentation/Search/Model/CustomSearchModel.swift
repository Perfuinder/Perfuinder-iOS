//
//  CustomSearchModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/21/24.
//

import Foundation

/// 향수 검색 기본 제공 키워드
enum SelectKeyword: String, CaseIterable {
    case sophisticated = "세련된"
    case bold = "대담한"
    case neutral = "중성적인"
    case exotic = "이국적인"
    case mature = "성숙한"
    case pure = "순수한"
    case adventurous = "모험적인"
    case luxurious = "고급스러운"
    case comfortable = "편안한"
    case vibrant = "활기찬"
    case mysterious = "미스터리"
    case intense = "강렬한"
    case romantic = "로맨틱한"
    case urban = "도시적인"
    case natural = "자연적인"
    case classic = "클래식"
    case modern = "모던"
    case fresh = "신선한"
    case sensual = "관능적인"
    case elegant = "우아한"
    case feminine = "여성적인"
}

/// 계절 이미지 선택용
enum SeasonImage: String, CaseIterable {
    case spring = "image-spring"
    case summer = "image-summer"
    case autumn = "image-fall"
    case winter = "image-winter"
}
