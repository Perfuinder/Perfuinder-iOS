//
//  PageIndicator.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/24/24.
//

import SwiftUI

/// 커스텀 Page Indicator
struct PageIndicator: UIViewRepresentable {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.numberOfPages = numberOfPages
        view.currentPageIndicatorTintColor = .black // 현재 페이지 색상
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3) // 다른 페이지 색상
        view.addTarget(context.coordinator, action: #selector(Coordinator.pageChanged), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = currentPage
        uiView.currentPageIndicatorTintColor = .black // 업데이트 시에도 색상 유지
        uiView.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PageIndicator
        
        init(_ parent: PageIndicator) {
            self.parent = parent
        }
        
        @objc func pageChanged(sender: UIPageControl) {
            parent.currentPage = sender.currentPage
        }
    }
}

#Preview {
    PageIndicator(numberOfPages: 5, currentPage: .constant(2))
}
