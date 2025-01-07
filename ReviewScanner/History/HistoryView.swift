//
//  HistoryView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 07/01/2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    
    var body: some View {
        if environmentData.userData.isLoggedIn {
            Text("TODO")
        }
        else {
            if let data = UserDefaults.standard.data(forKey: "scan-history"),
               let scanHistory = try? JSONDecoder().decode([ScanHistoryEntry].self, from: data) {
                ForEach(scanHistory.indices, id: \.self) { idx in
                    let entry = scanHistory[idx]
                    Text("ProductID: \(entry.id); Timestamp: \(entry.timestamp)")
                }
            } else {
                Text("No local scan history available")
            }
        }
    }
}

#Preview {
    HistoryView()
}
