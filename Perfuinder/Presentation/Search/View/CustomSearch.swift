//
//  CustomSearch.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// AI 탐색
struct CustomSearch: View {
    // MARK: - Properties
    /// 데이터 처리하는 뷰모델
    @StateObject var vm = CustomSearchViewModel()
        
    /// 더보기 버튼 누르면 선택지 키워드 20종 전부 다 보여주도록 결정해주는 변수
    @State var showAllSelectKeywords: Bool = false
    
    /// 2열 레이아웃
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
    // 다음 화면 넘어가기 가능여부
    /// 향수 검색 가능여부
    /// - 키워드가 하나라도 있다 || 선택된 이미지가 있다
    /// - 가격 이상하게 적지 않음: 최소가격 < 최대가격
    var isSearchPossible: Bool {
        // 직접 입력 가격 범위일 때, 최소 가격보다 최대 가격이 커야 함
        
        /// 가격범위 검증용
        var isPriceRangeValid: Bool = true
        
        // 가격 직접 입력일 때
        if vm.selectedPriceRange == .custom {
            // 입력된 가격 있는지 체크
            if let minPrice = vm.customPriceRange_min, let maxPrice = vm.customPriceRange_max {
                
                isPriceRangeValid = minPrice < maxPrice
            } else {
                // 입력된 가격 없으면 false
                isPriceRangeValid = false
            }
        }
        
        return (!vm.customKeywordList.isEmpty || !vm.selectedKeywordList.isEmpty || vm.selectedSeasonImage != nil) && isPriceRangeValid
    }
    
    // MARK: - View
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 30) {
                    // 키워드 입력 || 선택
                    selectKeywordSection
                    
                    // 이미지 선택
                    imageSection(maxWidth: geometry.size.width)
                    
                    // 가격대 선택
                    priceRangeSection
                    
                    // 향수 찾기 버튼
                    searchButton
                }
                .padding(.horizontal, 20)
                .navigationTitle("AI 탐색")
                .navigationBarTitleDisplayMode(.large)
            }
            .onTapGesture {
                print("키보드 내려야 하는데")
                self.hideKeyboard()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    CustomSearch()
}

// MARK: - View Components
extension CustomSearch {
    // MARK: 키워드
    /// 키워드 입력하는 부분 UI 전체
    private var selectKeywordSection: some View {
        VStack(spacing: 0) {
            // 섹션 제목
            Text("키워드")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            // 키워드 직접 입력하는 부분
            customKeywordInput
                .padding(.bottom, 10)
            
            WrapLayout {
                // 직접 입력한 키워드 제일 먼저 보여주기
                ForEach(vm.customKeywordList, id: \.self) { text in
                    customKeywordToken(text)
                }
                
                // 화면에서 보여줄 키워드 선택: 기본 키워드 10개, 모두 보기하면 20개
                let selectableKeywords = showAllSelectKeywords ? SelectKeyword.allCases : Array(SelectKeyword.allCases.prefix(10))
                
                // 선택지 키워드 토큰들
                ForEach(selectableKeywords, id: \.self) { keyword in
                    selectKeywordToken(keyword)
                }
                
                // 더보기/줄이기 버튼
                wrapButton
            }
        }
    }
    
    /// 키워드 집접 입력하기 부분
    private var customKeywordInput: some View {
        HStack {
            TextField("키워드 직접 입력하기", text: $vm.customKeyword)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(
                    Color.unselected
                )
                .clipShape(Capsule())
            
            Button {
                withAnimation (.easeInOut) {
                    // 텍스트필드에 있는 거 label로 내리기
                    vm.customKeywordList.insert(vm.customKeyword, at: 0)
                    
                    // 텍스트필드 비우기
                    vm.customKeyword.removeAll()
                }
                
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "plus")
                    Text("추가")
                }
                .font(.callout)
                .foregroundStyle(Color.secondary)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.unselected)
                .clipShape(Capsule())
            }

        }
    }
    
    /// 직접 입력한 키워드 토큰
    @ViewBuilder
    private func customKeywordToken(_ text: String) -> some View {
        HStack {
            // 텍스트
            Text(text)
                .foregroundStyle(Color.black)
            
            // 지우기 버튼
            Button {
                withAnimation(.easeInOut) {
                    // 직접 입력 키워드에서 삭제
                    vm.customKeywordList.removeAll { $0 == text }
                }
            } label: {
                Image(systemName: "multiply")
                    .foregroundStyle(Color.secondary)
            }
        }
        .font(.callout)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.unselected)
                .stroke(Color.customBlack, lineWidth: 1)
        )
    }
    
    /// 선택지 키워드 토큰
    @ViewBuilder
    private func selectKeywordToken(_ keyword: SelectKeyword) -> some View {
        Text(keyword.rawValue)
            .font(.callout)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            // 글씨) 선택 ? 흰색 : 검은색
            .foregroundStyle(vm.selectedKeywordList.contains(keyword) ? Color.white : Color.black)
            // 배경) 선택 ? 검은색 : 흰색
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(vm.selectedKeywordList.contains(keyword) ? Color.customBlack : Color.unselected)
            )
            .onTapGesture {
                withAnimation (.easeInOut) {
                    // 이미 선택한 키워드면 없애주기
                    if vm.selectedKeywordList.contains(keyword) {
                        vm.selectedKeywordList.removeAll(where: {$0.rawValue == keyword.rawValue})
                    }
                    // 기존 선택 키워드들 중에 없었으면 추가하기
                    else {
                        vm.selectedKeywordList.append(keyword)
                    }
                }
            }
    }
    
    /// 더보기 버튼 토큰
    private var wrapButton: some View {
        Button {
            withAnimation(.easeInOut) {
                showAllSelectKeywords.toggle()
            }
        } label: {
            Image(systemName: showAllSelectKeywords ? "chevron.up" : "chevron.down")
                .font(.callout)
                .foregroundStyle(Color.black)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .background(Color.main10)
                .clipShape(Capsule())
        }
    }
    
    // MARK: 이미지 선택
    @ViewBuilder
    private func imageSection(maxWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 섹션 제목
            Text("이미지 선택")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(SeasonImage.allCases, id: \.self) { seasonImage in
                    ZStack(alignment: .center) {
                        // 배경 네모: 선택되면 검은색으로 강조, 선택 안된거면 회색
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .stroke(vm.selectedSeasonImage == seasonImage ? Color.customBlack : Color.unselected, lineWidth: 2)
                            .frame(width: max((maxWidth-60)/2, 0), height: 150)
                        
                        // 계절별 이미지
                        Image(seasonImage.text)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: max((maxWidth - 80)/2, 0), height: 140)
                            .clipped()
                            .cornerRadius(11)
                    }
                    .onTapGesture {
                        print("onTapGesture")
                        // 탭한 경우 이미지 선택 / 선택해제
                        withAnimation (.easeInOut) {
                            // 선택된 이미지가 현재 이미지가 아니라면 탭된 이미지 선택하기
                            if vm.selectedSeasonImage != seasonImage {
                                print("이미지 선택하기")
                                vm.selectedSeasonImage = seasonImage
                                print("vm.selectedSeasonImage: \(vm.selectedSeasonImage?.text ?? "")")
                                print("seasonImage: \(seasonImage.text)")
                            }
                            // 이미 해당 이미지가 선택되어 있을 경우, 선택해제하기
                            else {
                                print("이미지 선택해제하기")
                                vm.selectedSeasonImage = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 가격대 선택
    private var priceRangeSection: some View {
        VStack(spacing: 0) {
            // 섹션 제목
            Text("키워드")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            // 가격대 토큰
            WrapLayout {
                ForEach(PriceRange.allCases, id: \.self) { range in
                    priceRangeToken(range)
                }
            }
            
            // 가격대 직접 입력 선택했을 때 가격 범위 입력하는 UI
            if vm.selectedPriceRange == .custom {
                customPriceRangeInput
                    .padding(.top, 15)
            }
        }
        // 가격 직접입력했다가 다른 걸로 변경하면 리셋
        .onChange(of: vm.selectedPriceRange) { oldValue, newValue in
            if newValue != .custom {
                print("가격대 초기화")
                vm.customPriceRange_min = nil
                vm.customPriceRange_max = nil
            }
        }
    }
    
    /// 선택지 키워드 토큰
    @ViewBuilder
    private func priceRangeToken(_ priceRange: PriceRange) -> some View {
        Text(priceRange.text)
            .font(.callout)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            // 글씨) 선택 ? 흰색 : 검은색
            .foregroundStyle(vm.selectedPriceRange == priceRange ? Color.white : Color.black)
            // 배경) 선택 ? 검은색 : 흰색
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(vm.selectedPriceRange == priceRange ? Color.customBlack : Color.unselected)
            )
            .onTapGesture {
                // 탭했을 때 선택된 가격대에 선택한 토큰 반영
                withAnimation (.easeInOut) {
                    vm.selectedPriceRange = priceRange
                }
            }
    }
    
    /// 직접입력 시 나오는 가격 입력 UI
    private var customPriceRangeInput: some View {
        HStack {
            // 최소가격
            singlePriceInput(isMin: true, inputPrice: $vm.customPriceRange_min)
            
            // ~
            Text("~")
            
            // 최대가격
            singlePriceInput(isMin: false, inputPrice: $vm.customPriceRange_max)
        }
    }
    
    
    /// 가격선택범위 한 개 UI
    /// - 2번 반복되서 그냥 한 번 만들어서 재활용함
    private func singlePriceInput(isMin: Bool, inputPrice: Binding<Int?>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // 텍스트
            Text(isMin ? "최소가격" : "최대가격")
                .font(.subheadline)
            
            // 가격입력 캡슐
            HStack {
                TextField("00,000", value: inputPrice, format: .number)
                    .keyboardType(.numberPad)
                
                Text("원")
                    .font(.callout)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.unselected)
            )
        }
    }
    
    /// 향수 찾기 버튼
    private var searchButton: some View {
        NavigationLink {
            // API 결과 추천받은 향수 리스트 Recommend 화면으로 넘기기
            Recommend(searchBody: vm.makeRequestDTO())
                .toolbarRole(.editor)
        } label: {
            Text("향수 찾기")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSearchPossible ? Color.customBlack : Color.gray.opacity(0.6))
                )
        }
        .disabled(!isSearchPossible)

    }
    
    
}
