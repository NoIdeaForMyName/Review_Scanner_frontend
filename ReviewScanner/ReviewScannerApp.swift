//
//  ReviewScannerApp.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 21/11/2024.
//

import SwiftUI

@main
struct ReviewScannerApp: App {
    @StateObject private var environmentData = EnvironmentData()

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(environmentData)
        }
    }
}
