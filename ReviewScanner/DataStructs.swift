//
//  DataStructs.swift
//  ReviewScanner
//
//  Created by m1 on 28/11/2024.
//

struct ProductData: Decodable, Equatable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let barcode: String
    let average_grade: Double
    let grade_count: Int
    let reviews: [ReviewData]
    
    public static func == (lhs: ProductData, rhs: ProductData) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.image == rhs.image && lhs.barcode == rhs.barcode && lhs.average_grade == rhs.average_grade && lhs.grade_count == rhs.grade_count && lhs.reviews == rhs.reviews
    }
}

struct ReviewData: Decodable, Equatable {
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
    
    public static func == (lhs: ReviewData, rhs: ReviewData) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.user == rhs.user && lhs.product_id == rhs.product_id && lhs.product_name == rhs.product_name && lhs.grade == rhs.grade && lhs.description == rhs.description && lhs.price == rhs.price && lhs.shop == rhs.shop && lhs.media == rhs.media
    }
}

struct UserData: Decodable, Equatable {
    let id: Int
    let email: String
    let nickname: String
    
    public static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.id == rhs.id && lhs.email == rhs.email && lhs.nickname == rhs.nickname
    }
}

struct LoggingData: Decodable, Equatable {
    let email: String
    let nickname: String
    
    public static func == (lhs: LoggingData, rhs: LoggingData) -> Bool {
        return lhs.email == rhs.email && lhs.nickname == rhs.nickname
    }
}

struct ShopData: Decodable, Equatable {
    let id: Int
    let name: String
    
    public static func == (lhs: ShopData, rhs: ShopData) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

struct ScanHistoryEntry: Codable, Equatable {
    let id: Int
    let timestamp: String
    
    public static func == (lhs: ScanHistoryEntry, rhs: ScanHistoryEntry) -> Bool {
        return lhs.id == rhs.id && lhs.timestamp == rhs.timestamp
    }
}

struct FullScanHistoryEntry: Decodable, Equatable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let average_grade: Double
    let timestamp: String
    
    public static func == (lhs: FullScanHistoryEntry, rhs: FullScanHistoryEntry) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.image == rhs.image && lhs.average_grade == rhs.average_grade && lhs.timestamp == rhs.timestamp
    }
}

struct ReviewMediaData: Decodable, Equatable {
    let id: Int
    let url: String
    
    public static func == (lhs: ReviewMediaData, rhs: ReviewMediaData) -> Bool {
        return lhs.id == rhs.id && lhs.url == rhs.url
    }
}
