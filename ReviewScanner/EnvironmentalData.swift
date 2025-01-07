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
        
    var isLoggedIn: Bool {
            return !email.isEmpty
        }
    
    public func clearData() -> Void {
        email = ""
        nickname = ""
    }
}
