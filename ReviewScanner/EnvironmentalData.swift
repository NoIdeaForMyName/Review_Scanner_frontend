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
    
    let guestService: API_GuestService = .init()
    let authService: AuthService = .init()
    
}

class ThisUserData {
    var email: String = ""
    var nickname: String = ""
    
    public func isLoggedIn() -> Bool {
        return email != ""
    }
}
