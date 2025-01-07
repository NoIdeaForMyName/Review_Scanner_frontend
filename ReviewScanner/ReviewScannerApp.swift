//
//  ReviewScannerApp.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import SwiftUI

//let environmentData = EnvironmentData()

let gradientColors: [Color] = [
    .gradientTop,
    .gradientBottom
]

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

@main
struct ReviewScannerApp: App {
    @StateObject var environmentData = EnvironmentData()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(environmentData)
        }
    }
}
