//
//  APIService.swift
//  ReviewScanner
//
//  Created by m1 on 28/11/2024.
//
import Foundation
import Combine

class APIService {
    let baseURL: URL = .init(string: "http://localhost:5000")!
    
    func fetchProductBarcode(barcode: String) -> AnyPublisher<ProductData, APIError> {
        let url = baseURL.appendingPathComponent("product_barcode/\(barcode)")
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
        let url = baseURL.appendingPathComponent("product/\(id)")
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

enum APIError: LocalizedError {
    case invalidResponse
    case decodingError
    case networkError(Error)
    case customMessage(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server responded with an invalid status."
        case .decodingError:
            return "Failed to decode the response data."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .customMessage(let message):
            return message
        }
    }
}


