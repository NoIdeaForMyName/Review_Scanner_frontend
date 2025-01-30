//
//  EnvironmentalData.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import Foundation
import Combine

class EnvironmentData: ObservableObject {
    var userData: ThisUserData = .init()
    
    let guestService: GuestServiceProtocol = API_GuestService()
    let authService: AuthServiceProtocol = API_AuthService()
        
}

class ThisUserData: ObservableObject {
    @Published var email: String = ""
    @Published var nickname: String = ""
    
    init() {
        clearCookies()
    }
        
    var isLoggedIn: Bool {
            return !email.isEmpty
        }
    
    public func clearData() -> Void {
        email = ""
        nickname = ""
        clearCookies()
    }
    
    private func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
            
        let keysToRemove = [
                "access_token",
                "refresh_token",
                "csrf_access_token",
                "csrf_refresh_token"
            ]
        for key in keysToRemove {
            UserDefaults.standard.removeObject(forKey: key)
        }

        UserDefaults.standard.synchronize()
    }
}
