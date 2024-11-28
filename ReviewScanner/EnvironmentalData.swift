//
//  EnvironmentalData.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import Foundation
import Combine

class EnvironmentData: ObservableObject {    
    @Published var userName: String = ""
    @Published var isLoggedIn: Bool = false
    
    let apiService: APIService = .init()
}


