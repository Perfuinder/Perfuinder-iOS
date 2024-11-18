//
//  HomeView.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import SwiftUI
import PhotosUI

struct Home: View {
    // MARK: - Properties
    @StateObject private var viewModel = HomeViewModel()
    
    /// 이미지 검색에서 사용할 이미지 PhotosPicker에서 선택
    @State var selectedItems: [PhotosPickerItem] = []
    
    /// PhotosPicker에서 선택된 이미지를 UIImage로 변환
    @State private var selectedImage: UIImage?
        
    // MARK: - View
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // 회색배경 구역
                    VStack(spacing: 20) {
                        // 계절별 추천향수
                        seasonPerfumeSection(maxWidth: geometry.size.width - 30)
                        
                        // 일반검색 박스
                        searchBox
                        
                        // 탐색버튼 2개 구역
                        HStack(alignment: .top, spacing: 20) {
                            // 이미지 분위기로 향수 찾기 버튼
                            imageSearchButton(maxWidth: (geometry.size.width - 50)/2)
                            
                            // AI 탐색 버튼
                            aiSearchButton(maxWidth: (geometry.size.width - 50)/2)
                        }
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 25)
                    // 구역 가름선
                    Rectangle()
                        .frame(width: geometry.size.width, height: 1)
                    
                    // 랜덤 브랜드 향수 구역
                    randomBrandSection
                    
                }
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        })
    }
}

#Preview {
    Home()
}

// MARK: - View Components
extension Home {
    /// 계절별 랜덤 향수 섹션
    @ViewBuilder
    private func seasonPerfumeSection(maxWidth: CGFloat) -> some View {
        VStack(alignment: .center, spacing: 0) {
            if let seasonData = viewModel.data?.seasonRandom.first {
                NavigationLink {
                    PerfumeInfo()
                        .toolbarRole(.editor) // back 텍스트 표시X
                    
                } label: {
                    VStack(spacing: 0) {
                        URLImage(url: seasonData.imageURL)
                            .frame(width: seasonData.brand == "조말론" ? 180 : 200, height: 160)
                            .clipped()
                            .padding(.top, 15)
                        
                        Text("\(seasonData.season.text)에 어울리는 추천향수")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                            .padding(.top, 15)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 2)
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 70)
                            .padding(.vertical, 5)
                        
                        HStack(spacing: 5) {
                            Text(seasonData.brand)
                            Text(seasonData.perfumeName)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(Color.black)
                        .padding(.bottom, 15)
                    }
                }

            }
            else {
                ProgressView()
                .frame(width: max(maxWidth, 0), height: 250)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.black)
        )
    }
    
    /// 일반검색 박스
    private var searchBox: some View {
        NavigationLink {
            NormalSearch()
                .toolbarRole(.editor)
            
        } label: {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.black)
                Text("향수 제품, 브랜드로 검색")
                    .foregroundStyle(Color.secondary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.main10)
                    .stroke(Color.black)
            )
        }
    }
    
    /// 이미지 분위기로 향수 찾기 버튼
    @ViewBuilder
    private func imageSearchButton(maxWidth: CGFloat) -> some View {
        NavigationLink {
            ImageSearch()
                .toolbarRole(.editor)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "photo")
                    .font(.title)
                Text("이미지 분위기로\n향수 찾기")
                    .multilineTextAlignment(.leading)
            }
            .foregroundStyle(Color.black)
            .padding([.top, .leading], 15)
            .frame(maxWidth: max(maxWidth, 0), maxHeight: 110, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .stroke(Color.black)
            )
        }

    }
    
    /// AI 탐색 버튼
    @ViewBuilder
    private func aiSearchButton(maxWidth: CGFloat) -> some View {
        NavigationLink {
            CustomSearch()
                .toolbarRole(.editor)
            
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "wand.and.rays")
                    .font(.title)
                    .foregroundStyle(Color.black)
                
                Text("AI 탐색")
                    .foregroundStyle(Color.black)
            }
            .padding([.top, .leading], 15)
            .frame(width: max(maxWidth, 0), height: 110, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .stroke(Color.black)
            )
        }
    }
    
    /// 랜덤 브랜드 향수 리스트 섹션
    private var randomBrandSection: some View {
        LazyVStack(alignment: .leading, spacing: 15) {
            Text(viewModel.data?.randomBrandName ?? "")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(viewModel.data?.brandRandom ?? [], id: \.id) { perfume in
                VStack(spacing: 0) {
                    HomeListCell(perfume: perfume)
                    Divider()
                }
            }
        }
        .padding(15)
        .background(Color.white)
    }
}
