//
//  PureToken.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import SwiftUI

// 기능 없이 그냥 라벨로 기능하는 토큰
struct PureToken: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .padding(.horizontal, 15)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

#Preview {
    PureToken(text: "토큰")
}
