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
    // MARK: 키워드 관련
    /// 직접 입력하는 키워드 String
    @State var customKeyword: String = ""
    
    /// 직접 입력해서 추가한 키워드
    @State var customKeywordList: [String] = []
    
    /// 기본 선택지 키워드들 중에 선택한 거
    @State var selectedKeywordList: [SelectKeyword] = []
    
    /// 더보기 버튼 누르면 선택지 키워드 20종 전부 다 보여주도록 결정해주는 변수
    @State var showAllSelectKeywords: Bool = false
    
    // MARK: 이미지 관련    
    /// 2열 레이아웃
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    /// 선택된 계절이미지
    @State var selectedSeasonImage: SeasonImage?
    
    // MARK: - View
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    // 키워드 입력 || 선택
                    selectKeywordSection
                    
                    // 이미지 선택
                    imageSection(maxWidth: geometry.size.width)
                }
                .padding(.horizontal, 20)
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    CustomSearch()
}

// MARK: - View Parts
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
                ForEach(customKeywordList, id: \.self) { text in
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
            TextField("키워드 직접 입력하기", text: $customKeyword)
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
                    customKeywordList.insert(customKeyword, at: 0)
                    
                    // 텍스트필드 비우기
                    customKeyword.removeAll()
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
                    customKeywordList.removeAll { $0 == text }
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
            .foregroundStyle(selectedKeywordList.contains(keyword) ? Color.white : Color.black)
            // 배경) 선택 ? 검은색 : 흰색
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(selectedKeywordList.contains(keyword) ? Color.customBlack : Color.unselected)
            )
            .onTapGesture {
                withAnimation (.easeInOut) {
                    // 이미 선택한 키워드면 없애주기
                    if selectedKeywordList.contains(keyword) {
                        selectedKeywordList.removeAll(where: {$0.rawValue == keyword.rawValue})
                    }
                    // 기존 선택 키워드들 중에 없었으면 추가하기
                    else {
                        selectedKeywordList.append(keyword)
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
                            .stroke(selectedSeasonImage == seasonImage ? Color.customBlack : Color.unselected, lineWidth: 2)
                            .frame(width: (maxWidth-60)/2, height: 150)
                        
                        // 계절별 이미지
                        Image(seasonImage.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: (maxWidth - 80)/2, height: 140)
                            .clipped()
                            .cornerRadius(11)
                    }
                    .onTapGesture {
                        // 탭한 경우 이미지 선택 / 선택해제
                        withAnimation (.easeInOut) {
                            // 선택된 이미지가 현재 이미지가 아니라면 탭된 이미지 선택하기
                            if selectedSeasonImage != seasonImage {
                                selectedSeasonImage = seasonImage
                            }
                            // 이미 해당 이미지가 선택되어 있을 경우, 선택해제하기
                            else {
                                selectedSeasonImage = nil
                            }
                        }
                    }
                }
            }
        }
    }
}
