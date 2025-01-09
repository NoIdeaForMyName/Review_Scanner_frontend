//
//  API_AuthService.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 12/12/2024.
//

import Foundation
import Combine
import UIKit

protocol AuthServiceProtocol {
    func register(email: String, password: String, nickname: String) -> AnyPublisher<Void, APIError>
    func login(email: String, password: String) -> AnyPublisher<LoggingData, APIError>
    func refreshToken() -> AnyPublisher<Void, APIError>
    func logout() -> AnyPublisher<Void, APIError>
    func addToHistory(barcode: String, timestamp: String) -> AnyPublisher<Void, APIError>
    func addToHistory(productId: Int, timestamp: String) -> AnyPublisher<Void, APIError>
    func addToHistory(entries: [ScanHistoryEntry]) -> AnyPublisher<Void, APIError>
    func fetchScanHistory() -> AnyPublisher<[ScanHistoryEntry], APIError>
    func fetchMyReviews() -> AnyPublisher<[ReviewData], APIError>
    func addProduct(barcode: String, name: String, description: String, image: UIImage) -> AnyPublisher<Void, APIError>
    func addReview(product_id: Int, title: String, description: String, grade: Int, price: Double, shopName: String, images: [UIImage]) -> AnyPublisher<Void, APIError>
}

class API_AuthService: AuthServiceProtocol {
    let baseURL: URL = .init(string: "http://127.0.0.1:8080")!
    
    func addToHistory(barcode: String, timestamp: String) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("add-to-history")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        let body: [String: Any] = [
            "barcode": barcode,
            "timestamp": timestamp
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
    func addToHistory(productId: Int, timestamp: String) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("add-to-history")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        let body: [String: Any] = [
            "id": productId,
            "timestamp": timestamp
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
    func addToHistory(entries: [ScanHistoryEntry]) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("add-list-to-history")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        
        let jsonData = try! JSONEncoder().encode(entries)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
    
    
    func fetchScanHistory() -> AnyPublisher<[ScanHistoryEntry], APIError> {
        let url = baseURL.appendingPathComponent("scan-history")
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
    
    func fetchMyReviews() -> AnyPublisher<[ReviewData], APIError> {
        let url = baseURL.appendingPathComponent("my-reviews")
        return APIResponse.fetchData(for: URLRequest(url: url))
    }
    
    func addProduct(barcode: String, name: String, description: String, image: UIImage) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("add-product")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        let body: [String: Any] = [
            "barcode": barcode,
            "name": name,
            "description": description,
            "image_base64": imageToBase64(image)!
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
    func addReview(product_id: Int, title: String, description: String, grade: Int, price: Double, shopName: String, images: [UIImage]) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("add-review")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let csrfToken = UserDefaults.standard.string(forKey: "csrf_access_token") {
            request.setValue(csrfToken, forHTTPHeaderField: "X-CSRF-TOKEN")
        }
        let body: [String: Any] = [
            "product_id": product_id,
            "title": title,
            "description": description,
            "grade": grade,
            "price": price,
            "shop_name": shopName,
            "images_base64": images.map {img in imageToBase64(img)!}
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
    func register(email: String, password: String, nickname: String) -> AnyPublisher<Void, APIError> {
        let url = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = [
            "email": email,
            "password": password,
            "nickname": nickname
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return APIResponse.fetchStatusVoid(for: request)
    }
    
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













class API_AuthServiceMock: AuthServiceProtocol {
    private let delayTime: TimeInterval = 0.5
    private var isLoggedIn = false
    
    func register(email: String, password: String, nickname: String) -> AnyPublisher<Void, APIError> {
        if email.contains("@") && password.count >= 6 && !nickname.isEmpty {
            return Just(())
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.badRequest("Invalid registration data"))
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<LoggingData, APIError> {
        if email == "test@test.com" && password == "password123" {
            isLoggedIn = true
            let mockData = LoggingData(email: email, nickname: "TestUser")
            return Just(mockData)
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.unauthorized("Invalid credentials"))
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func refreshToken() -> AnyPublisher<Void, APIError> {
        if isLoggedIn {
            return Just(())
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.unauthorized("Not logged in"))
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, APIError> {
        isLoggedIn = false
        return Just(())
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addToHistory(barcode: String, timestamp: String) -> AnyPublisher<Void, APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        return Just(())
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addToHistory(productId: Int, timestamp: String) -> AnyPublisher<Void, APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        return Just(())
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addToHistory(entries: [ScanHistoryEntry]) -> AnyPublisher<Void, APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        return Just(())
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchScanHistory() -> AnyPublisher<[ScanHistoryEntry], APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        let mockEntries = [
            ScanHistoryEntry(id: 1, timestamp: "03.01.2025"),
            ScanHistoryEntry(id: 2, timestamp: "03.01.2025")
        ]
        return Just(mockEntries)
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMyReviews() -> AnyPublisher<[ReviewData], APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        let mockReviews = [
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
            )
        ]
        return Just(mockReviews)
            .setFailureType(to: APIError.self)
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addProduct(barcode: String, name: String, description: String, image: UIImage) -> AnyPublisher<Void, APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        if !barcode.isEmpty && !name.isEmpty && !description.isEmpty {
            return Just(())
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.notFound("Invalid product data"))
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func addReview(product_id: Int, title: String, description: String, grade: Int, price: Double, shopName: String, images: [UIImage]) -> AnyPublisher<Void, APIError> {
        guard isLoggedIn else { return Fail(error: APIError.unauthorized("Not logged in")).eraseToAnyPublisher() }
        if !title.isEmpty && !description.isEmpty && (1...5).contains(grade) {
            return Just(())
                .setFailureType(to: APIError.self)
                .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.badRequest("Invalid review data"))
            .delay(for: .seconds(delayTime), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}



















func imageToBase64(_ image: UIImage, quality: CGFloat = 1.0) -> String? {
    if let data = image.pngData() ?? image.jpegData(compressionQuality: quality) {
        return data.base64EncodedString()
    }
    return nil
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
