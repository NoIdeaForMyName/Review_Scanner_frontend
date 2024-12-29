//
//  API_AuthService.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<LoggingData, APIError>
    func refreshToken() -> AnyPublisher<Void, APIError>
    func logout() -> AnyPublisher<Void, APIError>
}

class AuthService: AuthServiceProtocol {
    let baseURL: URL = .init(string: "http://localhost:8080")!
    
    func login(email: String, password: String) -> AnyPublisher<LoggingData, APIError> {
            let url = baseURL.appendingPathComponent("login")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    let response = APIResponse.getResponse(output)
                    if case .failure(let error) = response {
                        throw error
                    }
                    
                    // Odczyt plików cookie z odpowiedzi
                    if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                        for cookie in cookies {
                            UserDefaults.standard.set(cookie.value, forKey: cookie.name)
                        }
                    }
                    
                    // Upewnij się, że tokeny zostały zapisane
                    guard UserDefaults.standard.string(forKey: "access_token_cookie") != nil else {
                        throw APIError.unknown("Access token not found in cookies.")
                    }
                    
                    return output.data
                }
                .decode(type: LoggingData.self, decoder: JSONDecoder())
                .mapError { error in
                    APIError.mapError(error)
                }
                .eraseToAnyPublisher()
        }
        
        func refreshToken() -> AnyPublisher<Void, APIError> {
            let url = baseURL.appendingPathComponent("refresh")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Dodaj token CSRF do nagłówków
            if let csrfToken = UserDefaults.standard.string(forKey: "csrf_refresh_token") {
                request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
            }
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    let response = APIResponse.getResponse(output)
                    if case .failure(let error) = response {
                        throw error
                    }
                    
                    // Zaktualizuj pliki cookie
                    if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                        for cookie in cookies {
                            print("Cookie name: \(cookie.name), value: \(cookie.value)")
                            if cookie.name == "access_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "access_token")
                            } else if cookie.name == "refresh_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "refresh_token")
                            } else if cookie.name == "csrf_access_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "csrf_access_token")
                            } else if cookie.name == "csrf_refresh_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "csrf_refresh_token")
                            }
                        }
                    }
                    
                    return ()
                }
                .mapError { error in
                    APIError.mapError(error)
                }
                .eraseToAnyPublisher()
        }
    
    func logout() -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add CSRF token if needed
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        
        return APIResponse.fetchStatusVoid(for: request)
    }
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
