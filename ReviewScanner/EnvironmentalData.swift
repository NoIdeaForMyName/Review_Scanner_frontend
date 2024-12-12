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
    
    let guestService: API_GuestService = .init()
    let authService: AuthService = .init()
    
}

class ThisUserData: ObservableObject {
    @Published var email: String = ""
    @Published var nickname: String = ""
    
    public func isLoggedIn() -> Bool {
        return email != ""
    }
}
