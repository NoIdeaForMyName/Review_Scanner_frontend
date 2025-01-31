//
//  HomeViewModel.swift
//  ReviewScanner
//
//  Created by Michał Maksanty on 19/12/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published public var errorData: APIError? // Do przechowywania błędów logowania
    @Published public var error: Bool = false
    @Published public var logoutPerformed: Bool = false
    @Published public var fetchingScanHistoryDataPerformed: Bool = false
    @Published public var fetchingFullScanHistoryDataPerformed: Bool = false
    @Published public var scanHistoryData: [ScanHistoryEntry] = []
    @Published public var fullScanHistoryData: [FullScanHistoryEntry] = []

    @Published public var isLoading: Bool = false
    
    private var logoutCancellable: AnyCancellable? // Do przechowywania subskrypcji
    private var fetchCancellable: AnyCancellable? // Do przechowywania subskrypcji

    public func logoutAction(environmentData: EnvironmentData) {
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true

        logoutCancellable = environmentData.authService.logout()
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Logout completed successfully")
                    self?.logoutPerformed = true
                    environmentData.userData.clearData()
                case .failure(let error):
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: {})
    }
    
    public func fetchScanHistoryData(environmentData: EnvironmentData) {
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true
        
        fetchCancellable = environmentData.authService.fetchScanHistory()
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("fetching scan history data completed succesfully")
                    self?.fetchingScanHistoryDataPerformed = true
                case .failure(let error):
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] scanHistoryList in
                self?.scanHistoryData = scanHistoryList
            })
    }
    
    public func fetchFullScanHistoryData(environmentData: EnvironmentData, scanHistoryList: [ScanHistoryEntry]) {
        
        if scanHistoryList.isEmpty {
            fetchingFullScanHistoryDataPerformed = true
            return
        }
        
        errorData = nil // Wyczyść poprzedni błąd
        isLoading = true
        
        print("Scan history list: \(scanHistoryList)")

        fetchCancellable = environmentData.guestService.fetchProductsIds(ids: scanHistoryList.map() { $0.id })
            .receive(on: DispatchQueue.main) // Zapewnij, że aktualizacje UI będą na głównym wątku
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("fetching full scan history data completed succesfully")
                    self?.fetchingFullScanHistoryDataPerformed = true
                case .failure(let error):
                    self?.error = true
                    self?.errorData = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] prodDataList in
                self?.fullScanHistoryData = self?.mergeIntoFullScanHistoryList(scanHistoryList: scanHistoryList, productDataList: prodDataList) ?? []
            })
    }
    
    public func resetValues() {
        errorData = nil
        error = false
        logoutPerformed = false
        fetchingScanHistoryDataPerformed = false
        fetchingFullScanHistoryDataPerformed = false
        scanHistoryData = []
        fullScanHistoryData = []
        isLoading = false
    }
    
    public func mergeIntoFullScanHistoryList(scanHistoryList: [ScanHistoryEntry], productDataList: [ProductData]) -> [FullScanHistoryEntry] {
        let sortedScanHistoryList = scanHistoryList.sorted() { $0.id < $1.id }
        let sortedProductDataList = productDataList.sorted() { $0.id < $1.id }
        var fullScanHistoryList: [FullScanHistoryEntry] = []
        
        var scan_idx = 0
        var prod_idx = 0
        for _ in 0..<min(sortedScanHistoryList.count, sortedProductDataList.count) {
            
            var scanHistoryEntry = sortedScanHistoryList[scan_idx]
            var productData = sortedProductDataList[prod_idx]
            
            while scan_idx < sortedScanHistoryList.count-1 && scanHistoryEntry.id < productData.id {
                scan_idx += 1
                scanHistoryEntry = sortedScanHistoryList[scan_idx]
            }
            while prod_idx < sortedProductDataList.count-1 && productData.id < scanHistoryEntry.id {
                prod_idx += 1
                productData = sortedProductDataList[prod_idx]
            }
            
            if scanHistoryEntry.id == productData.id {
                fullScanHistoryList.append(FullScanHistoryEntry(
                    id: scanHistoryEntry.id,
                    name: productData.name,
                    description: productData.description,
                    image: productData.image,
                    average_grade: productData.average_grade,
                    timestamp: scanHistoryEntry.timestamp
                ))
            }
            scan_idx += 1
            prod_idx += 1
            
            if scan_idx >= sortedScanHistoryList.count || prod_idx >= sortedProductDataList.count {
                break
            }
        }
            
        return fullScanHistoryList.sorted() { $0.timestamp > $1.timestamp }
    }
    
// BEFORE UNIT TESTS:
    
//    public func mergeIntoFullScanHistoryList(scanHistoryList: [ScanHistoryEntry], productDataList: [ProductData]) -> [FullScanHistoryEntry] {
//        let sortedScanHistoryList = scanHistoryList.sorted() { $0.id < $1.id }
//        let sortedProductDataList = productDataList.sorted() { $0.id < $1.id }
//        var fullScanHistoryList: [FullScanHistoryEntry] = []
//        for (scanHistoryEntry, productData) in zip(sortedScanHistoryList, sortedProductDataList) {
//            fullScanHistoryList.append(FullScanHistoryEntry(
//                id: scanHistoryEntry.id,
//                name: productData.name,
//                description: productData.description,
//                image: productData.image,
//                average_grade: productData.average_grade,
//                timestamp: scanHistoryEntry.timestamp))
//        }
//            
//        return fullScanHistoryList.sorted() { $0.timestamp > $1.timestamp }
//    }
    
}
