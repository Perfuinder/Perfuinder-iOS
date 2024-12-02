//
//  PerfumeInfoViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 12/1/24.
//

import Foundation

/// 개별 향수 정보를 위한 뷰모델
class PerfumeInfoViewModel: ObservableObject {
    // MARK: Properties
    /// 향수 정보
    @Published var data: PerfumeInfoModel?
    
    /// 정보 요청할 향수 ID
    let perfumeID: Int
    
    /// 몇번째 용량의 가격 선택되었는지 확인하는 변수
    @Published var selectedPriceIndex: Int = 0
    
    // MARK: Initializer
    /// vm 생성할 때 정보 받아서 data에 입력하기
    init(id: Int) {
        self.perfumeID = id
        getPerfumeInfo(id: id) { success in
            if !success {
                // 실패코드 처리
            }
        }
    }
    
    // MARK: Methods
    /// id로 향수 정보 받기
    func getPerfumeInfo(id: Int, completion: @escaping (Bool) -> Void) {
        PerfumeInfoAPI.shared.getPerfumeInfo(id: id) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? PerfumeInfoResponse {
                    self.data = data.toPerfumeInfoEntity()
                } else {
                    print("FAIL: data as? PerfumeInfoResponse")
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
    
    /// 뷰에서 사용할 찜상태변경 함수
    func toggleFavorite() {
        requestFavoriteToggle { success in
            if success {
                print("\(self.perfumeID) 찜상태변경 성공")
            } else {
                print("\(self.perfumeID) 찜상태변경 실패")
            }
            
        }
    }
    
    /// 해당하는 id의 향수 찜 토글하기 API 호출
    func requestFavoriteToggle(completion: @escaping (Bool) -> Void) {
        FavoriteAPI.shared.favoriteToggle(id: self.perfumeID) { response in
            switch response {
            case .success(let data):
                print("API 호출해서 찜상태 변경 응답 받아옴")
                if data as! Bool {
                    self.data?.isFavorite = true
                } else {
                    self.data?.isFavorite = false
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
