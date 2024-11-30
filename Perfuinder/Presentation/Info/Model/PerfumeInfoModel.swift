//
//  PerfumeInfoModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 12/1/24.
//

/// 개별향수정보 페이지
struct PerfumeInfoModel {
    let imageUrl: String
    let brand: String
    let perfumeName: String
    let perfumeDesc: String
    let priceDTO: [PriceEntity]
    let seasonCode: SeasonCode
    let genderCode: GenderCode
    let keywords: [String]
    let mainNotes: [String]
    let notes: [InfoNoteModel]
    let celebrityDTO: [CelebrityDTO]
    let isFavorite: Bool
}

/// 탑/미들/베이스 정보
struct InfoNoteModel {
    let typeCode: NoteTypeCode
    let notes: [String]
    let desc: String
}

/// 탑/미들/베이스 노트 구분하기 위한 enum 타입
enum NoteTypeCode: Int {
    /// 탑노트: 0
    case top
    /// 미들노트: 1
    case middle
    /// 베이스노트: 2
    case base
}
