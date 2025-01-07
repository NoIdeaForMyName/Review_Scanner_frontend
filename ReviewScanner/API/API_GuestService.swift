//
//  APIService.swift
//  ReviewScanner
//
//  Created by m1 on 28/11/2024.
//
import Foundation
import Combine


protocol GuestServiceProtocol {
    func fetchProductBarcode(barcode:String) -> AnyPublisher<ProductData, APIError>
    func fetchProductId(id:Int) -> AnyPublisher<ProductData, APIError>
    func fetchProductsIds(ids:[Int]) -> AnyPublisher<[ProductData], APIError>
}


class API_GuestService: GuestServiceProtocol{
    let baseURL: URL = .init(string: "http://127.0.0.1:8080")!
    
    func fetchProductBarcode(barcode: String) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("/products/get-by-barcode")
            .appending(queryItems: [URLQueryItem(name: "barcode", value: barcode)])
        print(url)
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
    
    func fetchProductId(id: Int) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("products/\(id)")
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
    
    func fetchProductsIds(ids: [Int]) -> AnyPublisher<[ProductData], APIError> {
        let ids_string = ids.map { String($0) }.joined(separator: ",")
        let url = baseURL.appendingPathComponent("get-by-id-list")
            .appending(queryItems: [URLQueryItem(name: "ids", value: ids_string)])
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
}


class API_GuestMock: GuestServiceProtocol {
    private let delayTime: TimeInterval = 0.5 // Simulate network delay
    let mockupReviews = [
        ReviewData(
            id: 1,
            title: "Excellent product!",
            user: UserData(
                id: 1,
                email: "john.doe@example.com",
                nickname: "JohnDoe"
            ),
            product_id: 101,
            product_name: "Sample Product",
            grade: 5.0,
            description: "I am very satisfied with this product. It exceeded my expectations!",
            price: 49.99,
            shop: ShopData(
                id: 1,
                name: "Sample Shop"
            ),
            media: [
                ReviewMediaData(
                    id: 1,
                    url: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw"
                ),
                ReviewMediaData(
                    id: 2,
                    url: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw"
                )
            ]
        ),
        ReviewData(
            id: 2,
            title: "Good value for the price",
            user: UserData(
                id: 2,
                email: "jane.smith@example.com",
                nickname: "JaneSmith"
            ),
            product_id: 101,
            product_name: "Sample Product",
            grade: 4.0,
            description: "The product is good, but it could use some improvements.",
            price: 39.99,
            shop: ShopData(
                id: 2,
                name: "Another Shop"
            ),
            media: [
                ReviewMediaData(
                    id: 3,
                    url: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw"
                )
            ]
        )
    ]

    /// For barcode aaaaaaaa returns object, for barcode bbbbbbbb or any other it couldnt find it
    func fetchProductBarcode(barcode: String) -> AnyPublisher<ProductData, APIError> {
        if barcode.contains("aaa") {
            let product = ProductData(
                id: 1,
                name: "Mock Product",
                description: "This is a mock product description.",
                image: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw",
                barcode: barcode,
                average_grade: 4.5,
                grade_count: 100,
                reviews: mockupReviews
            )
            
            return Just(product)
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.notFound("Barcode not found"))
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
    }

    /// Returns correct result for id = 1, fails for other
    func fetchProductId(id: Int) -> AnyPublisher<ProductData, APIError> {
        if id == 1 {
            // Return a successful mock response
            let product = ProductData(
                id: id,
                name: "Mock Product",
                description: "This is a mock product description.",
                image: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw",
                barcode: "123456789",
                average_grade: 4.5,
                grade_count: 100,
                reviews: mockupReviews
            )

            return Just(product)
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            // Return an error for other IDs
            return Fail(error: APIError.notFound("Couldnt find Id"))
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }

    func fetchProductsIds(ids: [Int]) -> AnyPublisher<[ProductData], APIError> {
        let products = ids.map { id in
            ProductData(
                id: id,
                name: "Mock Product \(id)",
                description: "This is a mock product description for product \(id).",
                image: "https://v.wpimg.pl/NjAuanBlYQsgFxddbRdsHmNPQwcrTmJINFdbTG1VfVI5QFNWbQVgHTFbEQJtDWEMbh8RCyVDfV93RFlBKxwmBS8QPgwjGCsYKBQ-WHRcYAAxEAZMPw",
                barcode: "barcode_\(id)",
                average_grade: Double.random(in: 1.0...5.0),
                grade_count: Int.random(in: 1...100),
                reviews: []
            )
        }

        return Just(products)
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
