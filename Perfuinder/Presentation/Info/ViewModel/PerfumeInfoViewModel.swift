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
    
    /// 몇번째 용량의 가격 선택되었는지 확인하는 변수
    @Published var selectedPriceIndex: Int = 0
    
    // MARK: Initializer
    /// vm 생성할 때 정보 받아서 data에 입력하기
    init(id: Int) {
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
}
