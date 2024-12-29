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
}

class API_GuestService: GuestServiceProtocol{
    let baseURL: URL = .init(string: "http://localhost:8080")!
    
    func fetchProductBarcode(barcode: String) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("/products/get-by-barcode")
            .appending(queryItems: [URLQueryItem(name: "barcode", value: barcode)])
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
    
    func fetchProductId(id: Int) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("products/\(id)")
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
}
