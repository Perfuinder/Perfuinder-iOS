//
//  NormalSearch.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// 일반검색
struct NormalSearch: View {
    var body: some View {
        VStack {
            Text("일반검색 페이지")
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

#Preview {
    NormalSearch()
}
