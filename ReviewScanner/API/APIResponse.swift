//
//  APIError.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation
import Combine

// MARK: - APIResponse Enum

enum APIResponse {
    case successful(String)
    case created(String)
    // Add more cases as needed (e.g., updated, deleted)
    
    var responseDescription: String {
        switch self {
        case .successful(let message):
            return "Success: \(message)"
        case .created(let message):
            return "Created: \(message)"
        }
    }

    /// Processes the output from a URLSession data task and returns a Result type.
    /// - Parameter output: The output from URLSession.DataTaskPublisher.
    /// - Returns: A Result containing either an APIResponse or an APIError.
    static func getResponse(_ output: URLSession.DataTaskPublisher.Output) -> Result<(APIResponse, Data), APIError> {
        let (data, response) = output

        // Ensure the response is an HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unknown("Response is not correct HTTPURLResponse"))
        }

        switch httpResponse.statusCode {
        case 200:
            // Decode success message
            if let responseMessage = try? JSONDecoder().decode(ResponseMessage.self, from: data) {
                return .success((.successful(responseMessage.message), data))
            } else {
                return .success((.successful("Request was successful."), data))
            }

        case 201:
            // Decode created message
            if let responseMessage = try? JSONDecoder().decode(ResponseMessage.self, from: data) {
                return .success((.created(responseMessage.message), data))
            } else {
                return .success((.created("Resource created successfully."), data))
            }

        default:
            // Handle other status codes as errors
            let error = APIError.getError(data: data, response: httpResponse)
            return .failure(error)
        }
    }
    
    static func fetchData<decodable:Decodable>(for request:URLRequest) -> AnyPublisher<decodable, APIError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                let result = APIResponse.getResponse(output)
                switch result {
                case .success((let status, let data)):
                    if case .successful = status {
                        return data
                    }
                    throw APIError.unknown("expected successful response, got different response code: \(status.responseDescription)")
                case .failure(let error):
                    throw error
                }
            }
            .decode(type: decodable.self, decoder: JSONDecoder())
            .mapError { error in
                APIError.mapError(error)
            }
            .eraseToAnyPublisher()
    }

    static func fetchStatus(for request:URLRequest) -> AnyPublisher<APIResponse, APIError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                let result = APIResponse.getResponse(output)
                switch result {
                case .success((let status, let data)):
                    return status
                case .failure(let error):
                    throw error
                }
            }
            .mapError { error in
                APIError.mapError(error)
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchStatusVoid(for request:URLRequest) -> AnyPublisher<Void, APIError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                let result = APIResponse.getResponse(output)
                switch result {
                case .success((let status, let data)):
                    return ()
                case .failure(let error):
                    throw error
                }
            }
            .mapError { error in
                APIError.mapError(error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - APIError Enum

enum APIError: LocalizedError {
    case networkingError(String)
    case decodingError(String)
    case badRequest(String)
    case unauthorized(String)
    case forbidden(String)
    case notFound(String)
    case conflict(String)
    case internalServerError(String)
    case unknown(String)

    /// Provides a user-friendly error description.
    var errorDescription: String? {
        switch self {
        case .networkingError(let message):
            return "Networking error: \(message)"
        case .decodingError(let message):
            return "Failed to decode the response data: \(message)"
        case .badRequest(let message):
            return "Bad Request: \(message)"
        case .unauthorized(let message):
            return "Unauthorized: \(message)"
        case .forbidden(let message):
            return "Forbidden: \(message)"
        case .notFound(let message):
            return "Not Found: \(message)"
        case .conflict(let message):
            return "Conflict: \(message)"
        case .internalServerError(let message):
            return "Internal Server Error: \(message)"
        case .unknown(let message):
            return "Unknown Error: \(message)"
        }
    }
    
    static func mapError(_ error:Error) -> APIError {
        switch error {
        case let decodingError as DecodingError:
            return APIError.decodingError(decodingError.localizedDescription)
        case let apiError as APIError:
            // It's already your custom APIError
            return apiError
        default:
            // Networking or other errors
            return APIError.networkingError(error.localizedDescription)
        }
    }

    /// Determines the appropriate APIError based on the HTTP status code and response data.
    /// - Parameters:
    ///   - data: The data returned from the server.
    ///   - response: The HTTPURLResponse received.
    /// - Returns: An appropriate APIError.
    static func getError(data: Data, response: HTTPURLResponse) -> APIError {
        let statusCode = response.statusCode
        var message: String = HTTPURLResponse.localizedString(forStatusCode: statusCode)

        // Attempt to decode a more specific error message from the response data
        if let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
            message = errorMessage.error
        }

        switch statusCode {
        case 400:
            return .badRequest(message)
        case 401:
            return .unauthorized(message)
        case 403:
            return .forbidden(message)
        case 404:
            return .notFound(message)
        case 409:
            return .conflict(message)
        case 500:
            return .internalServerError(message)
        default:
            return .unknown(message)
        }
    }
}

// MARK: - Decodable Structs

/// Represents a successful response message from the API.
struct ResponseMessage: Decodable {
    let message: String
}

/// Represents an error message from the API.
struct ErrorMessage: Decodable {
    let error: String
}
