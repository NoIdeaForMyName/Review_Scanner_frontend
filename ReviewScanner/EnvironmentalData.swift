//
//  EnvironmentalData.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import Foundation
import Combine

class EnvironmentData {
    var userData: ThisUserData = .init()
    
    let guestService: GuestServiceProtocol = API_GuestService()
    let authService: AuthServiceProtocol = AuthService()
    
}

class ThisUserData {
    var email: String = ""
    var nickname: String = ""
    
    public func isLoggedIn() -> Bool {
        return email != ""
    }
    
    public func clearData() -> Void {
        email = ""
        nickname = ""
    }
}
