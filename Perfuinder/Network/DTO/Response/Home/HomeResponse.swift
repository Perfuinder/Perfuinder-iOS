//
//  HomeResponse.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation

// HomeResponse DTO
struct HomeResponse: Codable {
    let seasonPerfumes: [SeasonPerfumeDTO]
    let randomBrandName: String
    let brandPerfumes: [BrandPerfumeDTO]
}

// SeasonPerfume DTO
struct SeasonPerfumeDTO: Codable {
    let seasonCode: Int
    let perfumeId: Int
    let brand: String
    let perfumeName: String
    let imageUrl: String
}

// BrandPerfume DTO
struct BrandPerfumeDTO: Codable {
    let perfumeId: Int
    let perfumeName: String
    let perfumeDesc: String
    let imageUrl: String
}

extension HomeResponse {
    func toEntity() -> HomeModel {
            let seasonPerfumeEntity = seasonPerfumes.map {
                SeasonPerfume(season: SeasonCode(rawValue: $0.seasonCode) ?? .fall,
                              perfumeId: $0.perfumeId,
                              brand: $0.brand,
                              perfumeName: $0.perfumeName,
                              imageURL: $0.imageUrl)
            }
    
            let brandPerfumesEntity = brandPerfumes.map {
                RandomBrandPerfume(id: $0.perfumeId,
                                   name: $0.perfumeName,
                                   desc: $0.perfumeDesc,
                                   imageURL: $0.imageUrl)
            }
    
            return HomeModel(seasonRandom: seasonPerfumeEntity,
                             randomBrandName: randomBrandName,
                             brandRandom: brandPerfumesEntity)
        }
    
}
