//
//  CommonFunctions.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 08/01/2025.
//

import Foundation

func getLocalScanHistory() -> [ScanHistoryEntry] {
    if let data = UserDefaults.standard.data(forKey: "scan-history"),
       let scanHistory = try? JSONDecoder().decode([ScanHistoryEntry].self, from: data) {
        return scanHistory
    } else {
        return []
    }
}

func getCurrentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
    return dateFormatter.string(from: Date.now) //dateFormatter.string(from: Date.()))
}
