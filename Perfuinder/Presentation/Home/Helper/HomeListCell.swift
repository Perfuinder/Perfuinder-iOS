//
//  HomeListCell.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import SwiftUI

/// 랜덤브랜드 리스트의 셀 UI
struct HomeListCell: View {
    
    let perfume: RandomBrandPerfume
    
    let brand: String
    
    var body: some View {
        NavigationLink {
            PerfumeInfo()
                .toolbarRole(.editor) // back 텍스트 표시X
        } label: {
            HStack(alignment: .center, spacing: 25) {
                URLImage(url: perfume.imageURL)
                    .frame(width: 120, height: 160) // 이미지 크기
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 60, height: 140) // UI에서 취급되는 크기
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(perfume.name)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.black)
                    
                    Text(perfume.desc)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.black)
                }
                .padding(.leading, brand == "FORMENT" ? 25 : 0)
                
                Spacer()
            }
            .background(Color.white)
            .padding(.vertical, 15)
        }
    }
}


#Preview {
    VStack(spacing: 0) {
        HomeListCell(perfume: .init(id: 0, name: "시그니처 퍼퓸 코튼 366", desc: "비 온 뒤 물든 보라 빛 하늘, 바람을 타고 불어온 비눗방울과 햇살에 터지며 피어나는 부드러운 향기", imageURL: "https://theforment.com/web/product/big/202405/2c487c7b7d6a070534b96892988cd2fe.jpg"), brand: "FORMENT")
        Divider()
        HomeListCell(perfume: .init(id: 0, name: "오 드 퍼퓸 플레르 드 뽀", desc: "부드러운 옷 소매를 걷으면 손목에서 날법한 따뜻하고 포근한 체취의 향", imageURL: "https://image.sivillage.com/upload/C00001/goods/org/953/231108006980953.jpg?RS=750&SP=1"), brand: "")
        Divider()
        HomeListCell(perfume: .init(id: 0, name: "블랙베리 앤 베이 코롱", desc: "이제 막 수확한 월계수 잎의 신선함에 톡 쏘는 블랙베리 과즙을 가미한,  매력적이고 생기 넘치는 상쾌한 느낌의 향", imageURL: "https://www.jomalone.co.kr/media/export/cms/products/1000x1000/jo_sku_L32R01_1000x1000_0.png"), brand: "")
        Divider()
        HomeListCell(perfume: .init(id: 0, name: "집시 워터 오 드 퍼퓸", desc: "타고난 유목민이 구축한 다채로운 생활 방식에 대한 꿈을 일깨우는 향기", imageURL: "https://image.sivillage.com/upload/C00001/s3/goods/org/893/240820028362893.jpg?RS=300&SP=1"), brand: "")
        Divider()
    }
    .padding(.horizontal)
}
