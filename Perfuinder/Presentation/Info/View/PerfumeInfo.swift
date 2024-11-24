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
    
    // MARK: - View
    var body: some View {
        VStack {
            Text("PerfumeID: \(self.perfumeID)")
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    PerfumeInfo(perfumeID: 0)
}
