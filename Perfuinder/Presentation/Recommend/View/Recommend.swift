//
//  Recommend.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import SwiftUI

struct Recommend: View {
    // MARK: - Properties
    /// 검색 요청했던 데이터
    let searchBody: CustomSearchRequest
    
    /// 뷰모델
    @StateObject var vm: RecommendViewModel
    
    /// 카드 페이지 인덱스
    @State var selectedPageIndex: Int = 0
    
    
    // MARK: - View
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                // 추천 설명 텍스트
                Text(makeDescription())
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                // Page Indicator
                PageIndicator(numberOfPages: vm.data?.count ?? 0, currentPage: $selectedPageIndex)
                    .padding(.bottom, 10)
                
                // 추천향수 카드 리스트
                perfumeCardList
                
                // 비교하기 버튼
                compareButton
            }
            .background(Image("background"))
    }
}

#Preview {
    Recommend(
        searchBody: .init(
            keywords: "고급스러운", priceRangeCode: 2
        )
    )
}

// MARK: - View Components
extension Recommend {
    // 추천향수 카드 리스트
    private var perfumeCardList: some View {
        TabView(selection: $selectedPageIndex) {
            if let recommendedPerfumes = vm.data {
                ForEach(recommendedPerfumes.indices, id: \.self) { index in
                    NavigationLink {
                        // 개별 향수 누르면 
                        PerfumeInfo(perfumeID: recommendedPerfumes[index].perfumeId)
                    } label: {
                        recommendPerfumeCard(perfumeData: recommendedPerfumes[index])
                    }
                    .tag(index)
                }
            } else {
                ProgressView()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: 500)
    }
    
    /// 향수 한 개 카드
    private func recommendPerfumeCard(perfumeData: CustomSearchResponse) -> some View {
        ZStack(alignment: .topLeading) {
            // MARK: 향수 정보 카드
            VStack(alignment: .center, spacing: 0) {
                // 브랜드
                Text(perfumeData.brand)
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                // 제목
                Text(perfumeData.perfumeName)
                    .font(.headline)
                
                // 이미지
                URLImage(url: perfumeData.imageUrl)
                    .frame(width: 230, height: 150) // 이미지 크기
                    .frame(height: 200) // 프레임 크기
                    .clipped()
                    .padding(.vertical, 20)
                
                // 대표노트 있으면
                if !perfumeData.mainNotes.isEmpty {
                    // 토큰들로 보여주기
                    WrapLayout(alignment: .center) {
                        ForEach(perfumeData.mainNotes, id: \.self) { note in
                            PureToken(text: note)
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // 설명
                Text(perfumeData.perfumeDesc)
                    .multilineTextAlignment(.center)
                    .font(.callout)
            }
            .frame(width: 260)
            .foregroundStyle(Color.black)
            .padding(.horizontal, 15)
            .padding(.vertical, 30)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            // MARK: 찜하기 버튼
            Button {
                print("찜하기 버튼 눌림")
                // favorite toggle
                withAnimation(.easeInOut) {
                    vm.toggleFavorite(of: perfumeData.perfumeId)
                }
            } label: {
                Image(perfumeData.favorite ? "heart-fill" : "heart-empty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(15)
        }
        .frame(maxWidth: 290, maxHeight: 500)
    }
    
    /// 다른 향수와 비교하기 버튼
    private var compareButton: some View {
        VStack {
            NavigationLink {
                // Compare에 현재 비교하기 선택한 id & 추천받은 향수 ID 세트 전달하기
                Compare(compareType: .recommend,
                        firstID: self.vm.data?[selectedPageIndex].perfumeId,
                        recommendedIDs: vm.getPerfumeIDs())
                .toolbarRole(.editor)
            } label: {
                Text("다른 향수와 비교하기")
                    .foregroundStyle(Color.black)
                    .frame(width: 290, alignment: .center)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .disabled(vm.data == nil)
        }
    }
}

// MARK: - Functions
extension Recommend {
    /// 생성자: searchBody 받아서 뷰 만들기
    init(searchBody: CustomSearchRequest) {
        self.searchBody = searchBody
        _vm = StateObject(wrappedValue: RecommendViewModel(searchBody: searchBody, networking: true))
    }
    
    /// 검색한 키워드, 이미지, 가격대 이용해서 키워드 추천 설명 텍스트 만들기
    func makeDescription() -> String {
        // 만들어낼 텍스트
        var description: String = ""
                
        if let _ = searchBody.seasonCode {
            // 키워드, 이미지 모두 있다면
            if let keywords = searchBody.keywords {
                description.append(keywords)
                description.append("느낌이면서\n선택한 이미지와 어울리는")
            }
            // 이미지만 있다면
            else {
                description.append("선택한 이미지와 어울리는")
            }
        } else if let keywords = searchBody.keywords {
            // 키워드만 있다면
            description.append("\(keywords) 느낌의")
        }

        
        // 가격대: 선택한 가격대 설명
        switch searchBody.priceRangeCode {
        case 0:
            break
        case 1:
            description.append("\n5만원 이하의")
        case 2:
            description.append("\n5 - 10만원 가격대의")
        case 3:
            description.append("\n10 - 20만원 가격대의")
        case 4:
            description.append("\n20 - 30만원 가격대의")
        case 5:
            description.append("\n30만원 이상의")
        case 6:
            if let minPrice = searchBody.customPriceRangeMin,
                let maxPrice = searchBody.customPriceRangeMax {
                description.append("\n\(minPrice)~\(maxPrice) 사이 가격대의")
            }
        default:
            break
        }
        
        description.append("\n향수를 추천해드릴게요")
        
        return description
    }
}
