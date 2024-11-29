//
//  CompareSheet.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import SwiftUI

/// 향수 비교에서 향수 선택/변경할 때 보여줄 Sheet용 View
struct CompareSheet: View {
    // MARK: - Properties
    /// 현재 뷰를 sheet로 띄웠을 때 dissmiss시키기 위한 변수
    @Binding var showCompareSheet: Bool
    
    /// 추천향수리스트일지, 찜한향수 리스트일지 결정하는 변수
    let compareType: CompareType
    
    /// 선택된 표시해줄 향수 ID
    /// - 바꿀 향수가 아니라 비교하기 페이지에서 변경할 때 참고하기 위한 상대편 향수
    let toComparePerfumeID: Int?
    
    /// 이 뷰에서 선택해서 비교하기로 넘길 향수의 ID
    @Binding var currentPerfumeID: Int?
    
    /// 뷰에서 선택하는 향수 id
    /// - 완료 버튼 누르면 currentPerfumeID에 이 값 대입
    @State var selectedPerfumeID: Int
    
    /// 뷰모델
    @StateObject var vm: CompareSheetViewModel
    
    // MARK: - Initializers
    init(showCompareSheet: Binding<Bool>,
         compareType: CompareType,
         toComparePerfumeID: Int? = nil,
         currentPerfumeID: Binding<Int?>,
         perfumeData: [Int]? = nil) {
        
        _showCompareSheet = showCompareSheet
        self.compareType = compareType
        self.toComparePerfumeID = toComparePerfumeID
        _currentPerfumeID = currentPerfumeID
        selectedPerfumeID = currentPerfumeID.wrappedValue ?? 0
        
        // 추천향수 데이터로 vm 생성
        if compareType == .recommend {
            _vm = StateObject(wrappedValue: CompareSheetViewModel(idList: perfumeData ?? []))
        }
        // 찜한향수 데이터로 vm 생성
        else {
            _vm = StateObject(wrappedValue: CompareSheetViewModel())
        }
    }

    
    
    // MARK: - View
    var body: some View {      
        NavigationStack {
            VStack(spacing: 0) {
                if let listData = vm.data {
                    ScrollView {
                        ForEach(listData, id: \.perfumeID) { perfume in
                            VStack {
                                CompareSheetListCell(perfume: perfume,
                                                     isDisabled: perfume.perfumeID == toComparePerfumeID,
                                                     isSelected: perfume.perfumeID == selectedPerfumeID)
                                
                                Divider()
                            }
                            .onTapGesture {
                                withAnimation (.easeInOut) {
                                    if perfume.perfumeID != toComparePerfumeID {
                                        selectedPerfumeID = perfume.perfumeID
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        showCompareSheet = false
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("향수 고르기")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        // parentView로 현재 선택한 향수 ID 전달해서 비교페이지에서 변경
                        currentPerfumeID = selectedPerfumeID
                        showCompareSheet = false
                    }
                    .disabled(currentPerfumeID == selectedPerfumeID)    // 기존 id랑 똑같으면 바뀐 게 아니니까 완료 비활성화
                }
            }
        }
    }
}


#Preview {
    CompareSheet(showCompareSheet: .constant(true), compareType: .like, toComparePerfumeID: 1001, currentPerfumeID: .constant(1002), perfumeData: [1001, 1002, 1003, 1004, 1005])
}
