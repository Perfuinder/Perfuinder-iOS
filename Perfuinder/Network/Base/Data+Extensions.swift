//
//  Data+Extensions.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation

// 이미지 extension 시 data 수월하게 append하기 위함
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
