//
//  Recommend.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import SwiftUI

struct Recommend: View {
    /// 검색 요청할 정보
    let requestedSearch: CustomSearchRequest
    
    var body: some View {
        Text("Recommend")
    }
}

#Preview {
    Recommend(requestedSearch: .init())
}
