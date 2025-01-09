//
//  ProductPageModelView.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 07/01/2025.
//

import Foundation
import Combine

class ProductPageModelView: ObservableObject {
    @Published public var errorData: APIError? // Do przechowywania błędów logowania
    @Published public var productData: ProductData?
    @Published public var scanHistoryUploaded: Bool = false
    @Published public var error: Bool = false
    @Published public var isLoading: Bool = false
    
    private var scanHistoryUploadingCancellable: AnyCancellable?
    
    func addLocalScanHistoryEntry(productData: ProductData) {

        let newEntry = ScanHistoryEntry(id: productData.id, timestamp: getCurrentDateString())

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
    
    public func uploadScanHistory(environmentData: EnvironmentData, productData: ProductData) {
        
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true

        scanHistoryUploadingCancellable = environmentData.authService.addToHistory(productId: productData.id, timestamp: getCurrentDateString())
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Scan history entry uploaded succesfully")
                    self?.scanHistoryUploaded = true
                case .failure(let error):
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: {})
    }
}
