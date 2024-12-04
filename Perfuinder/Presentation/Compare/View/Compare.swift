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
    /// 뷰모델
    @StateObject var vm: CompareViewModel
    
    /// 2열 레이아웃
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    /// 용량별 가격에서 선택한 용량 인덱스 - 첫번째 향수
    @State var volumeIndexFirstSelected: Int = 0
    /// 용량별 가격에서 선택한 용량 인덱스 - 두번째 향수
    @State var volumeIndexSecondSelected: Int = 0
    
    /// 향수 변경/선택할 sheet 띄우기
    @State var showPerfumeSelectSheet: Bool = false
    
    /// 변경 선택한 향수가 첫번째향수인지?
    /// - true: first
    /// - false: second
    @State var isFirstToChange: Bool = true
    
    /// 추천향수중 비교일 때 사용할 생성자
    init(compareType: CompareType = .recommend, firstID: Int? = nil, secondID: Int? = nil, recommendedIDs: [Int]? = nil) {
        _vm = StateObject(wrappedValue: CompareViewModel(firstID: firstID,
                                                         secondID: secondID,
                                                         compareType: compareType,
                                                         recommendedPerfumeIDs: recommendedIDs))
    }
    
    
    // MARK: - View
    var body: some View {
        ScrollView {
            // 기본정보
            basicInfo
            
            // 가격/계절/성별/키워드 비주얼 정보들
            // 하나라도 있으면 정보 보이는 Grid 보여주고
            if vm.first != nil || vm.second != nil {
                visualInfo
                    .padding(.top, 30)
            }
            // 아무것도 없으면 "찜한 향수들을 비교해보세요" 박스 보여주기
            else {
                guideBoxLabel
                    .padding(.top, 80)
            }
            
            // 텍스트 정보들
            // 둘 중에 하나라도 있으면 보여주고, 없으면 그냥 아무것도 안띄우기
            if vm.first != nil || vm.second != nil {
                textInfo
            }
        }
        .navigationTitle("향수 비교")
        .navigationBarTitleDisplayMode(.large)
        // MARK: 비교할 향수 선택하는 sheet
        .sheet(isPresented: $showPerfumeSelectSheet) {
            if isFirstToChange {
                CompareSheet(showCompareSheet: $showPerfumeSelectSheet,
                             compareType: vm.compareType,
                             toComparePerfumeID: vm.secondID,
                             currentPerfumeID: $vm.firstID,
                             perfumeData: vm.recommendedPerfumeIDs)
            } else {
                CompareSheet(showCompareSheet: $showPerfumeSelectSheet,
                             compareType: vm.compareType,
                             toComparePerfumeID: vm.firstID,
                             currentPerfumeID: $vm.secondID,
                             perfumeData: vm.recommendedPerfumeIDs)
            }
        }
        // TODO: 비교할 향수 바뀌면 비교정보 호출하기
        // !!!: Compare_Register로 바꾼 다음에 다시 확인해봐야 함
        .onChange(of: vm.firstID ?? 0) { previousID, newID in
            // id로 비교향수정보 불러오기
            vm.getComparePerfume(isFirst: true, id: newID) { success in
                if success {
                    print("success: 1번향수 바꾸기 성공")
                } else {
                    print("fail: 1번향수 바꾸기 실패")
                }
            }
        }
        .onChange(of: vm.secondID ?? 0) { previousID, newID in
            // id로 비교향수정보 불러오기
            vm.getComparePerfume(isFirst: false, id: newID) { success in
                if success {
                    print("success: 2번향수 바꾸기 성공")
                } else {
                    print("fail: 2번향수 바꾸기 실패")
                }
            }
        }
    }
}

#Preview {
    Compare(compareType: .like)
}

// MARK: - Big Components
extension Compare {
    /// 경우의수 고려한 기본정보 컴포넌트
    private var basicInfo: some View {
        LazyVGrid(columns: columns, spacing: 50) {
            // 1열
            // 있으면 기본정보
            if let firstPerfume = vm.first {
                perfumeBasicInfo(imageURL: firstPerfume.imageURL, brand: firstPerfume.brand, title: firstPerfume.perfumeName, isFirst: true)
            }
            // 없으면 첫번째 향수 고르기 컴포넌트
            else {
                emptyBasicInfo(isFirst: true)
            }
            
            // 2열
            // 있으면 기본정보
            if let secondPerfume = vm.second {
                perfumeBasicInfo(imageURL: secondPerfume.imageURL, brand: secondPerfume.brand, title: secondPerfume.perfumeName, isFirst: false)
            }
            // 없으면 두번째 향수 고르기 컴포넌트
            else {
                emptyBasicInfo(isFirst: false)
            }
        }
    }
    
    /// 경우의수 고려한 비쥬얼 컴포넌트 구역(가격/계절/성별/키워드)
    private var visualInfo: some View {
        LazyVGrid(columns: columns, spacing: 50) {
            
            // MARK: 가격정보
            if let first = vm.first, !first.price.isEmpty {
                // 1열
                priceComponent(isFirst: true, priceSet: first.price)
                
            } else { Color.clear }
            
            // 2열
            if let second = vm.second, !second.price.isEmpty {
                priceComponent(isFirst: false, priceSet: second.price)
            } else { Color.clear }

            
            // MARK: 어울리는 계절
            // 1열
            if let first = vm.first {
                SeasonComponent(season: first.seasonCode)
            } else { Color.clear }
            // 2열
            if let second = vm.second {
                SeasonComponent(season: second.seasonCode)
            } else { Color.clear }
            
            // MARK: 성별
            // 1열
            if let first = vm.first {
                GenderComponent(gender: first.genderCode)
            } else { Color.clear }
            // 2열
            if let second = vm.second {
                GenderComponent(gender: second.genderCode)
            } else { Color.clear }
            
            // MARK: 대표 키워드
            // 1열
            if let first = vm.first {
                keywordsComponent(keywords: first.keywords)
            } else { Color.clear }
            // 2열
            if let second = vm.second {
                keywordsComponent(keywords: second.keywords)
            } else { Color.clear }
        }
    }
    
    private var textInfo: some View {
        VStack(spacing: 50) {
            // MARK: 설명
            textInfoComponent(componentType: .desc)
            
            // MARK: 대표노트
            textInfoComponent(componentType: .mainNotes)
            
            // MARK: 탑노트 설명
            textInfoComponent(componentType: .topNote)
            
            // MARK: 미들노트 설명
            textInfoComponent(componentType: .middleNote)
            
            // MARK: 베이스노트 설명
            textInfoComponent(componentType: .baseNote)
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 15)
    }
}


// MARK: - Small Components
extension Compare {
    /// 향수 기본정보(브랜드, 제목)
    private func perfumeBasicInfo(imageURL: String, brand: String, title: String, isFirst: Bool) -> some View {
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
            
            // 향수 이미지
            URLImage(url: imageURL)
                .frame(width: seasonPerfumeImageWidth, height: 160)
                .clipped()
                .padding(.bottom, 10)
            
            // 브랜드명
            Text(brand)
                .font(.body)
            
            // 향수 제품명
            Text(title)
                .font(.body)
                .fontWeight(.semibold)
            
            // 변경하기 버튼
            changeButton(isFirst: isFirst)
                .padding(.top, 10)
        }
    }
    
    /// 지정된 향수가 없을 때 향수 고르기 보여줄 컴포넌트
    private func emptyBasicInfo(isFirst: Bool) -> some View {
        VStack(alignment: .center, spacing: 10) {
            // 더미 직사각형 이미지
            Image(systemName: "rectangle.portrait.fill")
                .resizable()
                .frame(width: 64, height: 120)
                .foregroundStyle(Color.unselected)
            
            // 향수 고르기 버튼
            Button {
                isFirstToChange = isFirst
                showPerfumeSelectSheet.toggle()
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Text("향수 고르기")
                        .font(.headline)
                    
                    
                    Image(systemName: "chevron.down")
                }
                .foregroundStyle(Color.black)
            }
        }
    }
    
    /// 용량별 가격
    private func priceComponent(isFirst: Bool, priceSet: [PriceEntity]) -> some View {
        VStack(alignment: .center, spacing: 15) {
            var index: Int {
                get {
                    isFirst ? volumeIndexFirstSelected : volumeIndexSecondSelected
                }
                set(newIndex) {
                    if isFirst {
                        volumeIndexFirstSelected = newIndex
                    } else {
                        volumeIndexSecondSelected = newIndex
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
            
            HStack(alignment: .bottom, spacing: 0) {
                Text("\(priceSet[index].price)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.black)
                
                Text("원")
                    .foregroundStyle(Color.black)
            }
        }
    }
    
    /// 선택여부에 따라서 용량 캡슐모양 버튼으로 보여주기
    private func volumeCapsule(volume: Int, selected: Bool) -> some View {
        VStack {
            Text("\(volume)ml")
                .font(.caption)
                .fontWeight(selected ? .medium : .regular)
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
    private func changeButton(isFirst: Bool) -> some View {
        Button("변경하기") {
            // 타입에 따라서 다른 sheet 띄우기
            isFirstToChange = isFirst
            showPerfumeSelectSheet.toggle()
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
    private func textInfoComponent(componentType: TextComponentType) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            var title: String {
                switch componentType {
                case .desc: return "설명"
                case .mainNotes: return "향"
                case .topNote: return "탑노트"
                case .middleNote: return "미들노트"
                case .baseNote: return "베이스노트"
                }
            }
            
            
            /// 첫번째 열에 들어갈 텍스트 정보
            var firstText: String {
                switch componentType {
                case .desc: return vm.first?.perfumeDesc ?? ""
                case .mainNotes: return vm.first?.mainNotes.joined(separator: ", ") ?? ""
                case .topNote: return vm.first?.topNoteDesc ?? ""
                case .middleNote: return vm.first?.middleNoteDesc ?? ""
                case .baseNote: return vm.first?.baseNoteDesc ?? ""
                }
            }
            
            /// 두번째 열에 들어갈 텍스트 정보
            var secondText: String {
                switch componentType {
                case .desc: return vm.second?.perfumeDesc ?? ""
                case .mainNotes: return vm.second?.mainNotes.joined(separator: ", ") ?? ""
                case .topNote: return vm.second?.topNoteDesc ?? ""
                case .middleNote: return vm.second?.middleNoteDesc ?? ""
                case .baseNote: return vm.second?.baseNoteDesc ?? ""
                }
            }
            
            Text(title)
                .font(.headline)
            
            Divider()
            
            HStack(spacing: 30) {
                // 왼쪽 텍스트
                Text(firstText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                // 오른쪽 텍스트
                Text(secondText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
    
    /// 찜한 향수들을 비교해보세요 label
    private var guideBoxLabel: some View {
        Text("찜한 향수들을 비교해보세요")
            .font(.headline)
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

extension Compare {
    /// 텍스트 비교 항목
    enum TextComponentType {
        case desc
        case mainNotes
        case topNote
        case middleNote
        case baseNote
    }
}
