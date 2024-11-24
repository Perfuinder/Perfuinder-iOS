//
//  RecommendViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/23/24.
//

import Foundation

class RecommendViewModel: ObservableObject {
    /// 탐색 위해 입력하는 정보들
    let searchBody: CustomSearchRequest
    
    /// 검색결과 향수 데이터
    @Published var data: [CustomSearchResponse]?
    
    /// 찜하기 변경 받아온 결과
    var changedFavoriteBool: Bool?
    
    // MARK: 비교하기 할 때 필요한 변수
    @Published var toComparePerfumeID: Int?
    
    init(searchBody: CustomSearchRequest, networking: Bool) {
        self.searchBody = searchBody
        if networking {
            requestRecommend(request: searchBody) { success in
                if !success {
                    // 실패 결과 컨트롤
                }
            }
        }
        else {
            var perfumeData: [CustomSearchResponse] = []
            for i in 0...4 {
                perfumeData.append(CustomSearchResponse(perfumeId: i, brand: "JOMALONE", perfumeName: "머르 앤 통카 코롱 엔텐스\(i)", imageUrl: "https://www.jomalone.co.kr/media/export/cms/products/1000x1000/jo_sku_LGX201_1000x1000_0.png", mainNotes: ["우드", "세이지", "씨솔트"], perfumeDesc: "머르 나무의 매혹적인 레진 향이 뜨거운 공기를 따라 퍼지며 통카빈의 따뜻한 아몬드, 풍성한 바닐라 노트와 어우러져, 고급스러우면서 도취시키는 매력의 향", favorite: false))
            }
            self.data = perfumeData
        }
    }
    
    /// 추천향수 탐색 API 호출
    func requestRecommend(request: CustomSearchRequest, completion: @escaping (Bool) -> Void) {
        CustomSearchAPI.shared.getRecommend(request: request) { response in
            switch response {
            case .success(let data):
                // 성공 시, 서버에서 받은 향수 데이터 입력
                if let data = data as? [CustomSearchResponse] {
                    self.data = data
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
                    self.data![perfumeIndex].favorite = changedBool
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
