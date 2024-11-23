//
//  Recommend.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import SwiftUI

struct Recommend: View {
    // MARK: - Properties
    /// 뷰모델
    @StateObject var vm: RecommendViewModel
    
    // MARK: - View
    var body: some View {
        Text("Recommend")
    }
}

#Preview {
    Recommend(searchBody: .init())
}

// MARK: - View Components
extension Recommend {
    
}

// MARK: - Functions
extension Recommend {
    // searchBody 받아서 뷰 만들기
    init(searchBody: CustomSearchRequest) {
        _vm = StateObject(wrappedValue: RecommendViewModel(searchBody: searchBody))
    }
}
