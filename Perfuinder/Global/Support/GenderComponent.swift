//
//  GenderComponent.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/30/24.
//

import SwiftUI

/// 성별 컴포넌트
struct GenderComponent: View {
    /// 성별 enum
    let gender: GenderCode
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(gender.componentText)
                .font(
                    Font.custom("SF Pro Rounded", size: 60)
                        .weight(.bold)
                )
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(Color.black)
            
            Text(gender.text)
                .font(.body)
                .foregroundStyle(Color.black)
                
        }
    }
}

#Preview {
    GenderComponent(gender: .female)
}
