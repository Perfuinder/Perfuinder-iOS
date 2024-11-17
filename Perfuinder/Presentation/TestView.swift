//
//  TestView.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import SwiftUI

struct TestView: View {
    @StateObject var vm = TestVM()
    
    var body: some View {
        if let data = vm.data {
            VStack(alignment: .leading, spacing: 10) {
                Text(data.title)
                    .font(.title2)
                
                Text(data.body)
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TestView()
}
