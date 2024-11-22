//
//  KeyboardDismiss.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/21/24.
//

import SwiftUI

/// 키보드 바깥의 뷰 터치할 때 키보드가 내려갈 수 있도록
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
