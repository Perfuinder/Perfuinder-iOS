//
//  APIConstants.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation
import Alamofire
import UIKit

/// API 요청 과정 모듈화
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get } // 기본 URL
    var method: HTTPMethod { get } // HTTP 메서드
    var endPoint: String { get } // 엔드포인트
    var parameters: RequestParams { get } // 요청 파라미터
}

/// API 요청 시 parameter 정의
enum RequestParams {
    /// URL PathVariable
    case path(_ path: String)
    
    /// URL PathVariable & Body Parameter
    case pathBody(_ path: String, body: Encodable)
    
    /// URL 쿼리
    case query(_ query: Encodable)
    
    /// URL 쿼리 & Body Parameter
    case queryBody(_ query: Encodable, _ body: Encodable)
    
    /// 요청 Body Parameter
    case requestBody(_ body: Encodable)
    
    /// 매개변수가 없는 경우(주로 get에서 사용)
    case requestPlain
    
    /// 이미지 업로드하는 경우
    case uploadImage(_ image: UIImage)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}

extension TargetType {
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        // 파라미터 설정
        switch parameters {
        case .path(let path):
            // url 설정
            let url = try (baseURL + endPoint + path).encodeURL()!.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
//            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            return urlRequest
            
        case .pathBody(let path, let body):
            // url 설정
            let url = try (baseURL + endPoint + path).encodeURL()!.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
//            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            urlRequest.url = components?.url
            
            let bodyParams = body.toDictionary()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
            
            return urlRequest
            
        case .query(let query):
            // url 설정
            let url = try baseURL.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
//            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            let params = query.toDictionary()
            // parameter 중 nil값 처리
            let queryParams = params.compactMap { (key, value) -> URLQueryItem? in
                if let stringValue = value as? String, !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                else if let longValue = value as? Int64 {
                    return URLQueryItem(name: key, value: String(longValue))
                }
                return nil
            }
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
            return urlRequest
            
        case .queryBody(let query, let body):
            // url 설정
            let url = try baseURL.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
//            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            let params = query.toDictionary()
            // parameter 중 nil값 처리
            let queryParams = params.compactMap { (key, value) -> URLQueryItem? in
                if let stringValue = value as? String, !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                else if let longValue = value as? Int64 {
                    return URLQueryItem(name: key, value: String(longValue))
                }
                return nil
            }
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
            let bodyParams = body.toDictionary()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
            
            return urlRequest
            
        case .requestBody(let body):
            // url 설정
            let url = try baseURL.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            urlRequest.url = components?.url
            
            let bodyParams = body.toDictionary()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
            
            return urlRequest
            
        case .requestPlain:
            // url 설정
            let url = try baseURL.asURL()
            var urlRequest = try URLRequest(url: url, method: method)
//            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            var components = URLComponents(string: url.appendingPathComponent(endPoint.encodeURL()!).absoluteString)
            urlRequest.url = components?.url
            
            return urlRequest
            
        case .uploadImage(let image):
            // url 설정
            let url = try (baseURL + endPoint).asURL()
            var urlRequest = try URLRequest(url: url, method: method)
            
            // Boundary 설정
            let boundary = UUID().uuidString
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            // HTTP Body 생성
            urlRequest.httpBody = createMultipartBody(image: image, boundary: boundary)
            
            return urlRequest
        }
    }
    
    /// multipart/form-data에서 이미지 전송을 위한 body 만들기
    func createMultipartBody(image: UIImage, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        // 이미지 데이터 추가
        if let imageData = image.jpegData(compressionQuality: 0.99) {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"imageData\"; filename=\"image.jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }
        
        // Boundary 종료 추가
        body.append("--\(boundary)--\(lineBreak)") // End multipart form and return
        
        return body

    }
}
