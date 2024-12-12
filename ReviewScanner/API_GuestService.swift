//
//  APIService.swift
//  ReviewScanner
//
//  Created by m1 on 28/11/2024.
//
import Foundation
import Combine

class API_GuestService {
    let baseURL: URL = .init(string: "http://localhost:8080")!
    
    func fetchProductBarcode(barcode: String) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("products/get-by-barcode/\(barcode)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return output.data
            }
            .decode(type: ProductData.self, decoder: JSONDecoder())
            .mapError { error in
                (error as? APIError) ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchProductId(id: Int) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("products/\(id)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return output.data
            }
            .decode(type: ProductData.self, decoder: JSONDecoder())
            .mapError { error in
                (error as? APIError) ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
}

