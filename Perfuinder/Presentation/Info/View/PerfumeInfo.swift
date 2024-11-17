//
//  PerfumeInfo.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// 개별 향수 정보
struct PerfumeInfo: View {
    var body: some View {
        VStack {
            Text("개별 향수 정보")
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    PerfumeInfo()
}
