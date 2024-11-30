//
//  MyPageViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import Foundation

/// 마이페이지 뷰모델
class MyPageViewModel: ObservableObject {
    // 향수 리스트 데이터
    @Published var data: [MyPagePerfumeModel]?
    
    /// 찜하기 변경 받아온 결과
    var changedFavoriteBool: Bool?
    
    init() {
        getFavoritePerfumeList { success in
            if !success {
                // API 호출 실패 처리
            }
        }
    }
    
    /// 뷰에서 새로고침용으로 리스트 정보 받기 호출할 때 사용하는 함수
    func reloadFavoritePerfumeList() {
        getFavoritePerfumeList { success in
            if success {
                print("리스트 새로고침 - 성공!")
            } else {
                print("리스트 새로고침 - 실패")
            }
        }
    }
    
    /// 찜한향수 리스트 정보 받기
    func getFavoritePerfumeList(completion: @escaping (Bool) -> Void) {
        FavoriteAPI.shared.getFavoriteInfo() { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? [FavoritePerfumeResponse] {
                    self.data = data.map {
                        $0.toMyPageEntity()
                    }
                } else {
                    print("데이터 변환 실패")
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
    
    /// 해당하는 향수의 favorite 수정하기
    func toggleFavorite(of perfumeId: Int) {
        print("toggleFavorite 호출")
        
        // 찜하기 API 호출
        requestFavoriteToggle(id: perfumeId) { success in
            // API 호출 결과 따라서 해당 향수의 favorite 수정해주기
            if success {
                if let perfumeIndex = self.data?.firstIndex(where: {
                    perfumeId == $0.perfumeId }), let changedBool = self.changedFavoriteBool {
                    self.data![perfumeIndex].isFavorite = changedBool
                    print("찜상태 변경 성공!")
                }
            } else {
                print("찜하기 실패")
            }
        }
        
    }
    
    /// 해당하는 id의 향수 찜 토글하기 API 호출
    func requestFavoriteToggle(id: Int, completion: @escaping (Bool) -> Void) {
        FavoriteAPI.shared.favoriteToggle(id: id) { response in
            switch response {
            case .success(let data):
                print("API 호출해서 찜상태 변경 응답 받아옴")
                if data as! Bool {
                    self.changedFavoriteBool = true
                } else {
                    self.changedFavoriteBool = false
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
