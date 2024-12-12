//
//  APIError.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation

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
