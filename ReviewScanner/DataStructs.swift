//
//  DataStructs.swift
//  ReviewScanner
//
//  Created by m1 on 28/11/2024.
//

struct ProductData: Decodable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let barcode: String
    let average_grade: Double
    let grade_count: Int
    let reviews: [ReviewData]
}

struct ProductShortData: Decodable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let barcode: String
    let average_grade: Double
    let grade_count: Int
}

struct ReviewData: Decodable {
    let id: Int
    let title: String
    let user: UserData
    let product_id: Int
    let product_name: String
    let grade: Double
    let description: String
    let price: Double
    let shop: ShopData
    let media: [ReviewMediaData]
}

struct UserData: Decodable {
    let id: Int
    let email: String
    let nickname: String
}

struct LoggingData: Decodable {
    let email: String
    let nickname: String
}

struct ShopData: Decodable {
    let id: Int
    let name: String
}

struct ScanHistoryEntry: Codable {
    let id: Int
    let timestamp: String
}

struct ReviewMediaData: Decodable {
    let id: Int
    let url: String
}
