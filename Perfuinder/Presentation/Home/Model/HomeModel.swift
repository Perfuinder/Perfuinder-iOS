//
//  HomeModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/9/24.
//

import Foundation

/// 홈화면 정보 모델
struct HomeModel {
    let seasonRandom: [SeasonPerfume]
    let randomBrandName: String
    let brandRandom: [RandomBrandPerfume]
}

/// 계절에 어울리는 랜덤 향수
struct SeasonPerfume {
    let season: SeasonCode
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageURL: String
}

/// 브랜드 향수 리스트용 정보
struct RandomBrandPerfume: Identifiable {
    let id: Int
    let name: String
    let desc: String
    let imageURL: String
}

// TODO: 전체적으로 사용하는 파일에다가 옮기기
/// 계절코드
enum SeasonCode: Int {
    case spring
    case summer
    case fall
    case winter
    
    var text: String {
        switch self {
        case .spring: return "봄"
        case .summer: return "여름"
        case .fall: return "가을"
        case .winter: return "겨울"
        }
    }
}
