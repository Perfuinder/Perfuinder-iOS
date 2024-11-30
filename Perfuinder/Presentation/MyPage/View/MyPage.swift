//
//  MyPage.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// 마이페이지
struct MyPage: View {
    // MARK: - Properties
    @StateObject var vm: MyPageViewModel = .init()
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            titleBar
                .padding(.top, 30)
                .padding(.horizontal, 17)
                
            ScrollView {
                LazyVStack(spacing: 0) {
                    if let data = vm.data {
                        ForEach(data, id: \.perfumeId) { perfume in
                            NavigationLink {
                                PerfumeInfo(perfumeID: perfume.perfumeId).toolbarRole(.editor)
                            } label: {
                                VStack {
                                    makelistCell(of: perfume)
                                    Divider()
                                }
                            }

                        }
                        
                        // 다른 향수와 비교하기 버튼
                        compareButton
                            .padding(.bottom, 100)
                    }
                    else {
                        ProgressView()
                    }
                }
                .padding(.horizontal, 17)
            }
        }
    }
}

#Preview {
    MyPage()
}

// MARK: - View Components
extension MyPage {
    /// 제목 & 새로고침버튼
    private var titleBar: some View {
        HStack(alignment: .center) {
            // 제목
            Text("찜한 향수")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // 새로고침 버튼
            reloadButton
        }
    }
    
    /// 새로고침 버튼(리스트 다시 불러오기)
    private var reloadButton: some View {
        Button {
            withAnimation {
                vm.reloadFavoritePerfumeList()
            }
        } label: {
            Image(systemName: "arrow.trianglehead.counterclockwise")
        }
    }
    
    /// 마이페이지 리스트용 컴포넌트
    private func makelistCell(of perfume: MyPagePerfumeModel) -> some View {
        HStack(alignment: .center, spacing: 25) {
            // 찜하기 버튼
            favoriteButton(id: perfume.perfumeId, isFavorite: perfume.isFavorite)
                .padding(.trailing, perfume.brand == "FORMENT" ? 15 : 5)
                        
            URLImage(url: perfume.imageUrl)
                .frame(width: 120, height: 160) // 이미지 크기
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 60, height: 140) // UI에서 취급되는 크기
            
            VStack(alignment: .leading, spacing: 5) {
                Text(perfume.brand)
                    .font(.subheadline)
                    .foregroundStyle(Color.black)
                
                Text(perfume.perfumeName)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.black)
                
                Text(perfume.perfumeDesc)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.black)
                
                WrapLayout {
                    ForEach(perfume.keywords, id: \.self) { text in
                        PureToken(text: text)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.leading, perfume.brand == "FORMENT" ? 25 : 0)
            .frame(maxWidth: .infinity)
            
        }
        .padding(.vertical, 15)
        .background(Color.white)
    }
    
    /// 찜하기 버튼
    @ViewBuilder
    private func favoriteButton(id: Int, isFavorite: Bool) -> some View {
        Button {
            print("찜하기 버튼 눌림")
            // favorite toggle
            withAnimation(.easeInOut) {
                vm.toggleFavorite(of: id)
            }
        } label: {
            Image(isFavorite ? "heart-fill" : "heart-empty")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
        }
    }
    
    /// 다른 향수와 비교하기 버튼
    private var compareButton: some View {
        VStack {
            NavigationLink {
                // 찜한 향수들 사이 비교하기 페이지 띄우기
                Compare(compareType: .like)
                .toolbarRole(.editor)
            } label: {
                Text("다른 향수와 비교하기")
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .center)
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
