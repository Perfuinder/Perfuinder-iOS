//
//  ImageSearchViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit
import Alamofire

class ImageSearchViewModel: ObservableObject {
    // MARK: - Properties
    /// 이미지 검색에서 사용할 이미지 PhotosPicker에서 선택
    @Published var selectedItems: [PhotosPickerItem] = []
    
    /// PhotosPicker에서 선택된 이미지를 UIImage로 변환한 것
    @Published var selectedImage: UIImage?
    
    /// 이미지 키워드 리스트
    @Published var imageKeywords: [String] = []
    
    /// 전체 이미지 키워드 리스트 중, 유저가 선택한 키워드들
    @Published var selectedKeywords: [String] = []
    
    // MARK: - Functions
    func requestImageKeywords(_ image: UIImage, networking: Bool) {
        if networking {
            requestImageKeywords(image: image) { success in
                if !success {
                    print("키워드 요청 실패")
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.imageKeywords = ["감성적인", "분위기 있는", "세련된"]
            }
        }
    }
    
    // MARK: - API Calls
    func requestImageKeywords(image: UIImage, completion: @escaping (Bool) -> Void) {
        ImageSearchAPI.shared.getKeyword(image: image) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 키워드 입력
                if let data = data as? ImageSearchResponse {
                    self.imageKeywords = data.keywords
                }
                completion(true)
                
            case .requestErr(let message):
                print("Request Err: \(message)")
                completion(false)
            case .pathErr:
                print("Path Err")
                completion(false)
            case .serverErr(let message):
                print("Server Err: \(message)")
                completion(false)
            case .networkFail(let message):
                print("Network Err: \(message)")
                completion(false)
            case .unknown(let error):
                print("Unknown Err: \(error)")
                completion(false)
            }
        }
    }
}
