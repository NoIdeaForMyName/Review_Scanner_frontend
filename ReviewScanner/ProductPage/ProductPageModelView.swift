//
//  ProductPageModelView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 07/01/2025.
//

import Foundation

class ProductPageModelView: ObservableObject {
    func addLocalScanHistoryEntry(productData: ProductData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let newEntry = ScanHistoryEntry(id: productData.id, timestamp: dateFormatter.string(from: Date.now))

        // Retrieve existing history from UserDefaults
        var localHistory: [ScanHistoryEntry] = []
        if let data = UserDefaults.standard.data(forKey: "scan-history"),
           let decodedHistory = try? JSONDecoder().decode([ScanHistoryEntry].self, from: data) {
            localHistory = decodedHistory
        }

        // Update or append new entry
        if let index = localHistory.firstIndex(where: { $0.id == newEntry.id }) {
            localHistory[index] = newEntry
        } else {
            localHistory.append(newEntry)
        }

        // Save updated history back to UserDefaults
        if let encodedData = try? JSONEncoder().encode(localHistory) {
            UserDefaults.standard.set(encodedData, forKey: "scan-history")
        }
    }
}
