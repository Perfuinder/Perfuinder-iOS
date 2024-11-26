//
//  Compare.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/25/24.
//

import SwiftUI

/// 두 가지 향수 비교하기
struct Compare: View {
    // MARK: - Properties
    /// 2열 레이아웃
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @State var selectedFirstVolumeIndex: Int = 0
    @State var selectedSecondVolumeIndex: Int = 0
    
    
    // MARK: - View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                // MARK: 기본정보
                // first
                perfumeBasicInfo(imageURL: "https://image.sivillage.com/upload/C00001/goods/org/953/231108006980953.jpg?RS=750&SP=1", brand: "DIPTIQUE", title: "향수이름")
                // second
                perfumeBasicInfo(imageURL: "https://theforment.com/web/product/big/202402/f90e2db3d77c8541c3fbbe482a5a9891.png", brand: "FORMENT", title: "향수이름")
                
                // MARK: 가격정보
                // first
                priceComponent(isFirst: true, priceSet: [PriceDTO(volume: 50, price: 265050), PriceDTO(volume: 100, price: 25000), PriceDTO(volume: 150, price: 285000)])
                // second
                priceComponent(isFirst: false, priceSet: [PriceDTO(volume: 50, price: 265050), PriceDTO(volume: 100, price: 25000)])
                
                // MARK: 어울리는 계절
                // first
                seasonComponent(season: .winter)
                // second
                seasonComponent(season: .winter)
                
                // MARK: 성별
                // first
                genderComponent(gender: .female)
                // second
                genderComponent(gender: .female)
                
                // MARK: 대표 키워드
                // first
                keywordsComponent(keywords: ["로맨틱", "우아함", "고급스러움"])
                // second
                keywordsComponent(keywords: ["로맨틱", "신선함"])
                
            }

            VStack(spacing: 50) {
                // MARK: 설명
                commonCompareComponent(componentType: 0)
                
                // MARK: 대표노트
                commonCompareComponent(componentType: 1)
                
                // MARK: 탑노트 설명
                commonCompareComponent(componentType: 2)
                
                // MARK: 미들노트 설명
                commonCompareComponent(componentType: 3)
                
                // MARK: 베이스노트 설명
                commonCompareComponent(componentType: 4)
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    Compare()
}

// MARK: - Components
extension Compare {
    /// 향수 기본정보(브랜드, 제목)
    private func perfumeBasicInfo(imageURL: String, brand: String, title: String) -> some View {
        VStack(alignment: .center, spacing: 3) {
            /// 계절별 향수 브랜드에 따라 이미지 크기 조정하기위한 변수
            var seasonPerfumeImageWidth: CGFloat {
                switch brand {
                case "JOMALONE":
                    return 180
                case "FORMENT":
                    return 230
                default:
                    return 200
                }
            }
            

            URLImage(url: imageURL)
                .frame(width: seasonPerfumeImageWidth, height: 160)
                .clipped()
                .padding(.bottom, 10)
            
            Text(brand)
                .font(.body)
            
            Text(title)
                .font(.body)
                .fontWeight(.semibold)
            
            changeButton()
                .padding(.top, 10)
        }
    }
    
    /// 용량별 가격
    private func priceComponent(isFirst: Bool, priceSet: [PriceDTO]) -> some View {
        VStack(alignment: .center, spacing: 15) {
            var index: Int {
                get {
                    isFirst ? selectedFirstVolumeIndex : selectedSecondVolumeIndex
                }
                set(newIndex) {
                    if isFirst {
                        selectedFirstVolumeIndex = newIndex
                    } else {
                        selectedSecondVolumeIndex = newIndex
                    }
                }
            }
            HStack {
                ForEach(priceSet, id: \.volume) { price in
                    // first / second 구분방법 찾아야함..
                    volumeCapsule(volume: price.volume, selected: priceSet.firstIndex(where: {$0.volume == price.volume}) == index)
                        .onTapGesture {
                            index = priceSet.firstIndex(where: {$0.volume == price.volume})!
                        }
                }
            }
            Text("\(priceSet[index].price)원")
        }
    }
    
    /// 선택여부에 따라서 용량 캡슐모양 버튼으로 보여주기
    private func volumeCapsule(volume: Int, selected: Bool) -> some View {
        VStack {
            Text("\(volume)ml")
                .font(.caption)
                .fontDesign(.rounded)
                .foregroundStyle(selected ? Color.white : Color.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(selected ? Color.black : Color.unselected)
                )
        }
    }
    
    /// 변경하기 버튼
    private func changeButton() -> some View {
        // TODO: toCompareWith: ComparePerfumeInfo
        Button("변경하기") {
            // TODO: 타입에 따라서 다른 sheet 띄우기
        }
    }
    
    /// 성별 컴포넌트
    private func genderComponent(gender: GenderCode) -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text(gender.componentText)
                .font(
                    Font.custom("SF Pro Rounded", size: 60)
                        .weight(.bold)
                )
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            Text(gender.text)
                .font(.body)
                
        }
    }
    
    /// 계절별 컴포넌트
    private func seasonComponent(season: SeasonCode) -> some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: season.image)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            
            Text(season.text)
                .font(.body)
        }
    }
    
    /// 대표 키워드 컴포넌트
    private func keywordsComponent(keywords: [String]) -> some View {
        VStack(alignment: .center, spacing: 15) {
            ForEach(keywords, id: \.self) { keyword in
                Text(keyword)
                    .font(.headline)
            }
        }
    }
    
    /// 텍스트 비교 컴포넌트
    private func commonCompareComponent(componentType: Int) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            var title: String {
                switch componentType {
                case 0: return "설명"
                case 1: return "향"
                case 2: return "탑노트"
                case 3: return "미들노트"
                case 4: return "베이스노트"
                default: return ""
                }
            }
            
            // TODO: vm 정보 반영시키기
            var firstText: String {
                switch componentType {
                case 0: return "부드러운 옷 소매를 걷으면 손목에서 날법한 따뜻하고 포근한 체취의 향기"
                case 1: return "플로럴, 머스키, 우디"
                case 2: return "과일향이 가득한 활기찬 향기"
                case 3: return "과일향이 가득한 활기찬 향기"
                case 4: return "과일향이 가득한 활기찬 향기"
                default: return ""
                }
            }
            
            // TODO: vm 정보 반영시키기
            var secondText: String {
                switch componentType {
                case 0: return "빳빳한 와이셔츠 위로 알싸한 주니퍼베리 안개가 스민, 시크한 긴장감의 런더리 향수"
                case 1: return "로즈, 프루티, 시트러스"
                case 2: return "톡 쏘는 매콤함과 상쾌한 시트러스의 생동감"
                case 3: return "톡 쏘는 매콤함과 상쾌한 시트러스의 생동감"
                case 4: return "톡 쏘는 매콤함과 상쾌한 시트러스의 생동감"
                default: return ""
                }
            }
            
            Text(title)
                .font(.headline)
            
            Divider()
            
            HStack(spacing: 30) {
                Text(firstText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                Text(secondText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}
