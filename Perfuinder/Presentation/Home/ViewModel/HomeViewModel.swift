//
//  HomeViewModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import Foundation

/// 홈화면을 위한 뷰모델
class HomeViewModel: ObservableObject {
    @Published var data: HomeModel?
    
    init() {
        fetchData()
    }
    
    // TODO: API 호출해서 데이터 받아오기 방식으로 바꾸기
    func fetchData() {
        var randomBrandPerfumeArray: [RandomBrandPerfume] = []
        
        for i in 0...9 {
            randomBrandPerfumeArray.append(RandomBrandPerfume(id: i, name: "향수\(i)", desc: "이제 막 수확한 월계수 잎의 신선함에 톡 쏘는 블랙베리 과즙을 가미한,  매력적이고 생기 넘치는 상쾌한 느낌의 향", imageURL: "https://www.jomalone.co.kr/media/export/cms/products/1000x1000/jo_sku_L32R01_1000x1000_0.png"))
        }

        let seasonimageURL = "https://image.sivillage.com/upload/C00001/goods/org/548/231108006981548.jpg?RS=750&SP=1"
        
        data = HomeModel(seasonRandom:
                                SeasonPerfume(season: SeasonCode.fall,
                                              perfumeId: 0,
                                              brand: "딥디크",
                                              perfumeName: "오 드 퍼퓸 오르페옹",
                                              imageURL: seasonimageURL),
                              randomBrandName: "조말론",
                              brandRandom: randomBrandPerfumeArray)
    }
}
