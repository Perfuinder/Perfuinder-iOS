//
//  APIConstants.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation

/// BaseURL, Endpoint를 모아두는 파일
struct APIConstants {
    /// 서버 URL
    static let baseURL = devURL
        
    
    static let prodURL = ""
    
    /// 로컬 서버 URL
    static let devURL = "http://localhost:8080/api/v1"
    
    /// 홈 화면 조회 API
    static let homeURL = "/home"
    
    /// Gemini 향수 추천 API
    static let geminiSearchURL = "/gemini/search"
    
    /// 이미지 키워드 요청 API
    static let imageKeywordURL = "/gemini/image/keyword"
    
    /// 개별향수정보조회 API
    static let perfumeInfoURL = "/perfumes"
}

/// 한글 인코딩
/// url에 한글을 넣기 위함
extension String {
    /// 인코딩
    func encodeURL() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 디코딩
    func decodeURL() -> String? {
        return self.removingPercentEncoding
    }
}