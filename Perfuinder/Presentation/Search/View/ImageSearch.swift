//
//  ImageSearch.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI
import PhotosUI

/// 이미지 키워드 선택
struct ImageSearch: View {
    // MARK: - Properties
    /// viewmodel
    @StateObject var vm: ImageSearchViewModel = .init()
        
    /// PhotosPicker 보여주기 위한 변수
    @State private var isPickerPresented: Bool = false
    
    /// 선택완료 버튼 활성화 여부
    var isCompleteButtonEnabled: Bool {
        vm.selectedKeywords.count > 0
    }
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            // 선택된 이미지가 있다면 보여주기
            if let image = vm.selectedImage {
                // 선택된 이미지와 안내 텍스트
                selectedImageSection(image)
                
                // 키워드 선택 섹션
                keywordSelectSection
                    .padding(.vertical, 30)
                
                // 선택완료 버튼
                completeButton
                
            } else {
                // 선택된 이미지가 없다면 사진 다시 선택하기
                toSelectImageSection

            }
            
        }
        // 화면 켜지면 바로 이미지 픽커 켜지도록
        .onAppear {
            isPickerPresented.toggle()
        }
        // 사진 고르기
        .photosPicker(isPresented: $isPickerPresented, selection: $vm.selectedItems, maxSelectionCount: 1, matching: .images)
        // 사진 고르면(변경되면) 이미지 보이도록 하기
        .onChange(of: vm.selectedItems.first) { oldItem, newItem in
            if let newItem = newItem {
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data, let uiImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                // 선택한 이미지 화면에 띄우기
                                vm.selectedImage = uiImage
                                
                                // 기존 키워드 지우기
                                vm.imageKeywords.removeAll()
                                vm.selectedKeywords.removeAll()
                                
                                // TODO: 이미지 키워드 요청 API 호출하기
                                vm.requestImageKeywords(uiImage, networking: true)
                            }
                            
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
        .background(
            Image("background")
        )
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    ImageSearch()
}

extension ImageSearch {
    /// 이미지 & 키워드 선택 안내 텍스트 보여주는 UI
    @ViewBuilder
    private func selectedImageSection(_ image: UIImage) -> some View {
        VStack(spacing: 0) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .onTapGesture {
                    // 이미지 클릭하면 재선택 가능하도록
                    isPickerPresented.toggle()
                }
                .overlay {
                    Image(systemName: "pencil")
                        .font(.headline)
                        .foregroundStyle(Color.secondary)
                }
            
            Text("검색하신 이미지에서\n원하는 키워드를 선택해주세요")
                .multilineTextAlignment(.center)
                .padding(.top, 15)
        }
    }
    
    /// 선택된 이미지가 없을 때 선택하기 위한 UI
    private var toSelectImageSection: some View {
        VStack {
            // 선택된 이미지가 없다면 사진 다시 선택하기
            Button {
                isPickerPresented.toggle()
            } label: {
                VStack(spacing: 15) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(Color.secondary)
                        .frame(width: 170, height: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 11)
                                .foregroundStyle(Color.gray)
                        )
                    Text("원하는 이미지의 사진을 선택해보세요")
                }
            }
        }
    }
    
    /// 키워드 선택하는 UI
    private var keywordSelectSection: some View {
        VStack(spacing: 10) {
            // 이미지 키워드 없으면 로딩중 동글뱅이 띄우기
            if vm.imageKeywords.isEmpty {
                ProgressView()
            }
            // 이미지 키워드 있으면 토큰으로 보여주기
            else {
                ForEach(vm.imageKeywords, id: \.self) { keyword in
                    token(keyword)
                        .onTapGesture {
                            // selected 배열에 없다면 추가
                            if !vm.selectedKeywords.contains(keyword) {
                                withAnimation(.easeInOut) {
                                    vm.selectedKeywords.append(keyword)
                                }
                            }
                            // selected 배열에 있으면 제거
                            else {
                                withAnimation(.easeInOut) {
                                    vm.selectedKeywords.removeAll(where: { $0 == keyword })
                                }
                            }
                        }
                }
            }
        }
    }
    
    /// 선택 완료 버튼
    private var completeButton: some View {
        NavigationLink {
            // 선택한 키워드 담아서 화면 넘기기
            Recommend(searchBody: CustomSearchRequest(keywords: vm.selectedKeywords.joined(separator: ", "), priceRangeCode: 0))
                .toolbarRole(.editor)
        } label: {
            Text("선택 완료")
                .font(.callout)
                .foregroundStyle(isCompleteButtonEnabled ? Color.black : Color.secondary)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white)
                        .stroke(isCompleteButtonEnabled ? Color.black : Color.secondary, lineWidth: 1)
                )
        }
        // 하나 이상 선택되면 활성화
        .disabled(!isCompleteButtonEnabled)
        .padding(.horizontal, 55)

    }
    
    /// 토큰 1개 UI
    @ViewBuilder
    private func token(_ text: String) -> some View {
        HStack(spacing: 10) {
            Text(text)
                .font(.callout)
                .foregroundStyle(Color.black)
        }
        .foregroundStyle(Color.white)
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white)
                .stroke(Color.black, lineWidth: vm.selectedKeywords.contains(text) ? 1 : 0) // 선택된 경우 검정색 테두리 생성
        }
    }
}
