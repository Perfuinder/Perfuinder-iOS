//
//  HomeViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import Foundation
import Alamofire

/// 홈화면을 위한 뷰모델
class HomeViewModel: ObservableObject {
    @Published var data: HomeModel?
    
    init() {
        fetchData() { isSuccess in
            if !isSuccess {
                print("Failed to fetch data")
            }
        }
    }
    
    // TODO: API 호출해서 데이터 받아오기 방식으로 바꾸기
    func fetchData(completion: @escaping (Bool) -> (Void)) {
        HomeAPI.shared.getHome { response in
            switch response {
            case .success(let data):
                // TODO: 데이터 처리
                if let data = data as? HomeResponse {
                    self.data = data.toEntity()
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
        
        
        // API로 안받아오고 더미데이터로 넣을 때(예비)
        /*
        var randomBrandPerfumeArray: [RandomBrandPerfume] = []
        
        for i in 0...9 {
            randomBrandPerfumeArray.append(RandomBrandPerfume(id: i, name: "향수\(i)", desc: "이제 막 수확한 월계수 잎의 신선함에 톡 쏘는 블랙베리 과즙을 가미한,  매력적이고 생기 넘치는 상쾌한 느낌의 향", imageURL: "https://theforment.com/web/product/big/202405/2c487c7b7d6a070534b96892988cd2fe.jpg"))
        }

        let seasonimageURL = "https://theforment.com/web/product/big/202405/2c487c7b7d6a070534b96892988cd2fe.jpg"
        
        data = HomeModel(seasonRandom:
                                [SeasonPerfume(season: SeasonCode.fall,
                                              perfumeId: 0,
                                              brand: "FORMENT",
                                              perfumeName: "오 드 퍼퓸 오르페옹",
                                              imageURL: seasonimageURL)],
                              randomBrandName: "JOMALONE",
                              brandRandom: randomBrandPerfumeArray)
         */
        
    }
}

