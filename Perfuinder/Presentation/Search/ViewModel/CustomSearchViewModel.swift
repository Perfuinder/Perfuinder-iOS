//
//  CustomSearchViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation
import Alamofire
import SwiftUI

class CustomSearchViewModel: ObservableObject {
    // MARK: - Properties
    
    // MARK: 키워드 관련
    /// 직접 입력하는 키워드 String
    @Published var customKeyword: String = ""
    
    /// 직접 입력해서 추가한 키워드
    @Published var customKeywordList: [String] = []
    
    /// 기본 선택지 키워드들 중에 선택한 거
    @Published var selectedKeywordList: [SelectKeyword] = []
    
    
    // MARK: 이미지 관련
    /// 선택된 계절이미지
    @Published var selectedSeasonImage: SeasonImage?
    
    // MARK: 가격대 관련
    /// 선택된 가격대
    @Published var selectedPriceRange: PriceRange = .all
    
    /// 직접 입력하는 가격대일 때, 최소 가격
    @Published var customPriceRange_min: Int?
    
    /// 직접 입력하는 가격대일 때, 최대 가격
    @Published var customPriceRange_max: Int?
    
    // MARK: - Function    
    /// 뷰에서 선택한 데이터 조합해서 CustomSearchRequest DTO 만들어주기
    func makeRequestDTO() -> CustomSearchRequest {
        print("-----makeRequestDTO()------")
        // 키워드
        var keywords: String?
        
        // 직접입력 + 선택 합산용 배열
        var keywordsTotal: [String] = []
        // 선택한 키워드 있으면 배열에 추가
        if !selectedKeywordList.isEmpty {
            keywordsTotal = selectedKeywordList.map { $0.rawValue }
        }
        // 직접입력 키워드 있으면 배열에 추가
        keywordsTotal.append(contentsOf: customKeywordList)
        
        // 선택하거나 입력한 키워드가 있다면 객체 입력용 변수에 string 형태로 추가
        if !keywordsTotal.isEmpty {
            keywords = keywordsTotal.joined(separator: ", ")
        }
        
        print("- keywords: \(keywords ?? "nil")")
        
        // 계절 이미지코드
        let seasonCode: Int? = self.selectedSeasonImage?.rawValue
        print("- seasonCode: \(seasonCode)")
        print("- priceRangeCode: \((self.selectedPriceRange.rawValue))")
        print("- customPriceRangeMin: \((self.customPriceRange_min))")
        print("- customPriceRangeMax: \((self.customPriceRange_max))")
        
        // 결과 객체 리턴
        return CustomSearchRequest(
            keywords: keywords,
            seasonCode: seasonCode,
            priceRangeCode: self.selectedPriceRange.rawValue,
            customPriceRangeMin: self.customPriceRange_min,
            customPriceRangeMax: self.customPriceRange_max
        )
    }
}
