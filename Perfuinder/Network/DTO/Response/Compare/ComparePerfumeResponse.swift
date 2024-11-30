//
//  ComparePerfumeResponse.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/28/24.
//

// 향수 비교를 위한 정보 네트워킹용 DTO
struct ComparePerfumeResponse: Codable {
    let perfumeId: Int
    let imageUrl: String
    let brand: String
    let perfumeName: String
    let priceDTO: [PriceDTO]
    let seasonCode: Int
    let genderCode: Int
    let keywords: [String]
    let description: String
    let mainNotes: [String]
    let topNoteDesc: String
    let middleNoteDesc: String
    let baseNoteDesc: String
}

/// 용량별 가격
struct PriceDTO: Codable {
    let volume: String
    let price: Int
    
    /// "V_" 붙어있는 volume String -> Int로 바꿔주는 함수
    func toEntity() -> PriceEntity? {
        let numberString = self.volume.replacingOccurrences(of: "V_", with: "")
        return PriceEntity(volume: Int(numberString) ?? 0, price: price)
    }
}

// functions
extension ComparePerfumeResponse {
    func toEntity() -> ComparePerfumeInfo {
        
        return ComparePerfumeInfo(perfumeID: self.perfumeId,
                                  imageURL: self.imageUrl,
                                  brand: self.brand,
                                  perfumeName: self.perfumeName,
                                  price: priceDTO2Entity(toChange: self.priceDTO),
                                  seasonCode: SeasonCode(rawValue: self.seasonCode) ?? .spring,
                                  genderCode: GenderCode(rawValue: self.genderCode) ?? .unisex,
                                  keywords: self.keywords,
                                  perfumeDesc: self.description,
                                  mainNotes: self.mainNotes,
                                  topNoteDesc: self.topNoteDesc,
                                  middleNoteDesc: self.middleNoteDesc,
                                  baseNoteDesc: self.baseNoteDesc)
    }
    
    // Price DTO 변환 관련
    /// DTO 배열 Entity 배열로 변환해주기
    func priceDTO2Entity(toChange dtos: [PriceDTO]) -> [PriceEntity] {
        return dtos.compactMap { dto in
            return dto.toEntity()
        }
    }
}
