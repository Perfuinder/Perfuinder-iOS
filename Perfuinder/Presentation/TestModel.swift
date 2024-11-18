//
//  TestModel.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/18/24.
//

import Foundation

struct TestModel: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    private enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
}
