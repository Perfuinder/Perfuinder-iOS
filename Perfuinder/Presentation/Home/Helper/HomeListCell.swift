//
//  HomeListCell.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/11/24.
//

import SwiftUI

/// 랜덤브랜드 리스트의 셀 UI
struct HomeListCell: View {
    
    let perfume: RandomBrandPerfume
    
    var body: some View {
        NavigationLink {
            PerfumeInfo()
                .toolbarRole(.editor) // back 텍스트 표시X
        } label: {
            HStack(alignment: .center, spacing: 25) {
                URLImage(url: perfume.imageURL)
                    .frame(width: 140, height: 130)
                    .clipped()
                    .offset(y: -20)
                    .frame(width: 60, height: 120)
                    .padding(.top, 15)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(perfume.name)
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    
                    Text(perfume.desc)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.black)
                }
                
                Spacer()
            }
            .background(Color.white)
            .padding(.vertical, 10)
        }
    }
}


//#Preview {
//    HomeListCell()
//}
