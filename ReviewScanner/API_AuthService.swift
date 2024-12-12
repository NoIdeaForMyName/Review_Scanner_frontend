//
//  API_AuthService.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation
import Combine

class AuthService {
    let baseURL: URL = .init(string: "http://localhost:8080")!
    
    func login(email: String, password: String) -> AnyPublisher<Void, APIError> {
            let url = baseURL.appendingPathComponent("login")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.invalidResponse
                    }
                    
                    // Odczyt plików cookie z odpowiedzi
                    if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                        for cookie in cookies {
                            print("Cookie name: \(cookie.name), value: \(cookie.value)")
                            if cookie.name == "access_token_cookie" {
                                UserDefaults.standard.set(cookie.value, forKey: "access_token_cookie")
                            } else if cookie.name == "refresh_token_cookie" {
                                UserDefaults.standard.set(cookie.value, forKey: "refresh_token_cookie")
                            } else if cookie.name == "csrf_access_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "csrf_access_token")
                            } else if cookie.name == "csrf_refresh_token" {
                                UserDefaults.standard.set(cookie.value, forKey: "csrf_refresh_token")
                            }
                        }
                    }
                    
                    // Upewnij się, że tokeny zostały zapisane
                    guard UserDefaults.standard.string(forKey: "access_token_cookie") != nil else {
                        throw APIError.customMessage("Access token not found in cookies.")
                    }
                    
                    return ()
                }
                .mapError { error in
                    (error as? APIError) ?? .networkError(error)
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
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw APIError.invalidResponse
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
                    (error as? APIError) ?? .networkError(error)
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
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                return ()
            }
            .mapError { error in
                (error as? APIError) ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
