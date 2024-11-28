//
//  EnvironmentalData.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import Foundation

class EnvironmentData: ObservableObject {
    @Published var userName: String = ""
    @Published var isLoggedIn: Bool = false
    
    func logIn(name: String) {
        userName = name
        isLoggedIn = true
    }
    
    func logOut() {
        userName = ""
        isLoggedIn = false
    }
}
