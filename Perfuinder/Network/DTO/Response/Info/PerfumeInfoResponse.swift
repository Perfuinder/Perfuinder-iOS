//
//  PerfumeInfoResponse.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import Foundation

// MARK: - PerfumeInfoResponse
/// 향수개별정보 API 연결을 위한 DTO
struct PerfumeInfoResponse: Codable {
    let imageUrl: String
    let brand: String
    let perfumeName: String
    let perfumeDesc: String
    let priceDTO: [PriceDTO]
    let seasonCode: Int
    let genderCode: Int
    let keywords: [String]
    let mainNotes: [String]
    let notes: [InfoNoteDTO]
    let celebrityDTO: [CelebrityDTO]
    let favorite: Bool
}

extension PerfumeInfoResponse {
    func toPerfumeInfoEntity() -> PerfumeInfoModel {
        return PerfumeInfoModel(imageUrl: self.imageUrl,
                                brand: self.brand,
                                perfumeName: self.perfumeName,
                                perfumeDesc: self.perfumeDesc,
                                priceDTO: priceDTO2Entity(toChange: self.priceDTO),
                                seasonCode: SeasonCode(rawValue: self.seasonCode) ?? .spring,
                                genderCode: GenderCode(rawValue: self.genderCode) ?? .female,
                                keywords: self.keywords,
                                mainNotes: self.mainNotes,
                                notes: infoNoteDTO2Entity(toChange: self.notes),
                                celebrityDTO: self.celebrityDTO,
                                isFavorite: self.favorite)
    }
    
    /// PriceDTO 배열 Entity 배열로 변환해주기
    func priceDTO2Entity(toChange dtos: [PriceDTO]) -> [PriceEntity] {
        return dtos.compactMap { dto in
            return dto.toEntity()
        }
    }
    
    /// InfoNoteDTO 배열 Entity 배열로 변환해주기
    func infoNoteDTO2Entity(toChange dtos: [InfoNoteDTO]) -> [InfoNoteModel] {
        return dtos.compactMap { dto in
            return dto.toEntity()
        }
    }

}

// MARK: - InfoNoteDTO
/// 향수정보에서 탑/미들/베이스 보여줄 정보
struct InfoNoteDTO: Codable {
    let typeCode: Int
    let notes: [String]
    let desc: String
}

extension InfoNoteDTO {
    /// InfoNoteDTO를 엔터티인 InfoNoteModel로 만들어주기
    func toEntity() -> InfoNoteModel? {
        return InfoNoteModel(typeCode: NoteTypeCode(rawValue: self.typeCode) ?? .top,
                             notes: self.notes,
                             desc: self.desc)
    }

}

// MARK: - CelebrityDTO
/// 향수정보 어쩌구
struct CelebrityDTO: Codable {
    let name: String
    let url: String
}
