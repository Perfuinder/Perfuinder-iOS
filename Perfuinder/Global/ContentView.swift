//
//  ContentView.swift
//  Perfuinder
//
//  Created by 석민솔 on 10/28/24.
//

import SwiftUI

/// root view
struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Tab1: 홈
                NavigationStack {
                    Home()
                }
                .tabItem {
                    Image(selectedTab == 0 ? "home_selected" : "home_deselected")
                    Text("홈")
                }
                .tag(0)
                
                
                // Tab2: 마이페이지
                MyPage()
                    .tabItem {
                        Image(selectedTab == 1 ? "myPage_selected" : "myPage_deselected")
                        Text("마이")
                    }
                    .tag(1)
            }
        }
    }

}

#Preview {
    ContentView()
}
