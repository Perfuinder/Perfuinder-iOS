//
//  SeasonComponent.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import SwiftUI

/// 계절별 컴포넌트
struct SeasonComponent: View {
    /// 컴포넌트 만들 계절 enum
    let season: SeasonCode
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: season.image)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .foregroundStyle(Color.black)
            
            Text(season.text)
                .font(.body)
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    SeasonComponent(season: .spring)
}
