//
//  PerfumeInfo.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// 개별 향수 정보
struct PerfumeInfo: View {
    // MARK: - Properties
    /// 정보 요청할 향수 ID
    let perfumeID: Int
    
    @StateObject var vm: PerfumeInfoViewModel
    
    init(perfumeID: Int) {
        self.perfumeID = perfumeID
        _vm = StateObject(wrappedValue: PerfumeInfoViewModel(id: perfumeID))
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if let data = vm.data {
                URLImage(url: data.imageUrl)
                Text("어느 브랜드꺼? : \(data.brand)")
            } else {
                ProgressView()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    PerfumeInfo(perfumeID: 1001)
}
